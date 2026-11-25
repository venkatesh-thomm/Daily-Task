#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Highly-available kops cluster on AWS
#   * 3 control-plane nodes, one per AZ (etcd quorum survives an AZ loss)
#   * 3 worker instance groups, one per AZ, autoscaled 1..4 each
#   * private topology (nodes in private subnets, NAT per AZ) + bastion
#   * Calico CNI (enforces NetworkPolicy)
#   * Addons managed by kops: EBS CSI, metrics-server, cluster-autoscaler,
#     cert-manager, AWS Load Balancer Controller (for the ALB Ingress)
#
# Prereqs: aws cli, kops, kubectl; IAM user with kops permissions;
#          an SSH public key at ~/.ssh/id_ed25519.pub (or edit SSH_KEY)
# ---------------------------------------------------------------------------
set -euo pipefail

export AWS_REGION="${AWS_REGION:-us-east-1}"
export ZONES="${ZONES:-${AWS_REGION}a,${AWS_REGION}b,${AWS_REGION}c}"

# Use a Route53 sub-domain you own (e.g. k8s.devopscrack.com) OR a gossip
# name ending in .k8s.local (no DNS needed).
export NAME="${NAME:-vprofile.k8s.local}"
export STATE_BUCKET="${STATE_BUCKET:-vprofile-kops-state-$(aws sts get-caller-identity --query Account --output text)}"
export KOPS_STATE_STORE="s3://${STATE_BUCKET}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519.pub}"

CP_SIZE="${CP_SIZE:-t3.medium}"
NODE_SIZE="${NODE_SIZE:-t3.large}"

echo ">> 1. State store bucket (versioned + encrypted)"
if ! aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$AWS_REGION"
  else
    aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$AWS_REGION" \
      --create-bucket-configuration LocationConstraint="$AWS_REGION"
  fi
  aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
  aws s3api put-bucket-encryption --bucket "$STATE_BUCKET" \
    --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
fi

echo ">> 2. Cluster spec (not applied yet)"
kops create cluster \
  --name "$NAME" \
  --cloud aws \
  --zones "$ZONES" \
  --control-plane-zones "$ZONES" \
  --control-plane-count 3 \
  --control-plane-size "$CP_SIZE" \
  --node-count 3 \
  --node-size "$NODE_SIZE" \
  --topology private \
  --networking calico \
  --bastion \
  --ssh-public-key "$SSH_KEY"

echo ">> 3. Enable addons"
kops edit cluster "$NAME" \
  --set spec.certManager.enabled=true \
  --set spec.awsLoadBalancerController.enabled=true \
  --set spec.metricsServer.enabled=true \
  --set spec.clusterAutoscaler.enabled=true

echo ">> 4. Let each per-AZ node group autoscale 1..4"
for ig in $(kops get ig --name "$NAME" | awk 'NR>1 && $1 ~ /^nodes/ {print $1}'); do
  kops edit ig "$ig" --name "$NAME" --set spec.minSize=1 --set spec.maxSize=4
done
# If your kops version lacks 'edit --set', run 'kops edit cluster/ig' and set the same fields by hand.

echo ">> 5. Build the cluster"
kops update cluster --name "$NAME" --yes --admin
kops validate cluster --name "$NAME" --wait 20m

kubectl get nodes -L topology.kubernetes.io/zone
