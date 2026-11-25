# vprofile – Containerize & deploy on a highly-available kops cluster

## What's in here

```
Dockerfile                    # multi-stage: Maven build -> Tomcat 9 / JRE 11, non-root
.dockerignore
Docker-db/Dockerfile          # MySQL 5.7 + seed SQL, no baked-in passwords
compose.yml                   # local smoke test
kops/create-cluster.sh        # HA cluster: 3 control planes + nodes in 3 AZs
k8s/
  01-namespace.yaml           # namespace with "restricted" Pod Security
  02-resourcequota.yaml       # ResourceQuota + LimitRange
  03-configmap.yaml           # JDBC URL, DB name
  04-secret.yaml              # TEMPLATE - fill in locally, never commit real values
  05-storageclass.yaml        # encrypted gp3 EBS, Retain
  06-statefulset-db.yaml      # MySQL (1 replica + 20Gi volume)
  07-service.yaml             # devopsdb, mysql-headless, vprofile-app
  08-deployment.yaml          # app (3+ pods spread over 3 AZs)
  09-hpa.yaml                 # 3 -> 9 pods on CPU
  10-pdb.yaml                 # keep >= 2 app pods during maintenance
  11-ingress.yaml             # AWS ALB with sticky sessions
  12-networkpolicy.yaml       # default deny; app:8080 open; MySQL only from app
```

## How HA is achieved, layer by layer

| Layer | Mechanism | Survives |
|---|---|---|
| Control plane | 3 masters / etcd members, one per AZ (kops) | loss of 1 AZ |
| Worker nodes | 3 per-AZ instance groups, self-healing ASGs + cluster-autoscaler | node / AZ loss |
| Entry point | AWS ALB across 3 AZs, health check `/health` | AZ loss |
| App pods | ≥3 replicas, hard zone spread, PDB `minAvailable: 2`, HPA 3→9, `maxUnavailable: 0` rollouts, probes, preStop drain | pod / node / AZ loss, deploys, kops rolling-updates |
| Sessions | ALB sticky cookie (logins are kept in Tomcat memory) | see note below |
| Database | MySQL StatefulSet on EBS | pod crash, node loss in the **same** AZ |

**Database limit.** The StatefulSet must stay at `replicas: 1`, because a second replica would be a separate empty database, not a copy. Its EBS volume lives in one AZ, so if that whole AZ goes down the database is offline until the AZ recovers. The data is not lost. If you later need the database to survive an AZ outage, move it to Amazon RDS Multi-AZ. Only `06-statefulset-db.yaml` and the `devopsdb` Service would change.

**Sessions.** If an app pod dies, users pinned to it have to log in again. Removing that needs an external session store (e.g. Spring Session + Redis), which is a code change.

---

## 1. Build & push the images

```bash
export REG=docker.io/<your-dockerhub-user>
docker build -t $REG/vprofile-app:1.0.0 .
docker build -t $REG/vprofile-db:1.0.0  Docker-db/
docker push  $REG/vprofile-app:1.0.0
docker push  $REG/vprofile-db:1.0.0
```
Optional local test: `docker compose up --build` → http://localhost:8080

If you build on an Apple-silicon Mac, add `--platform linux/amd64`. The `mysql:5.7` image is amd64-only.

Then replace `YOUR_DOCKERHUB_USER` in `k8s/06-statefulset-db.yaml` and `k8s/08-deployment.yaml`. For a private repo, also create an `imagePullSecret`.

## 2. Create the kops cluster

```bash
export AWS_REGION=us-east-1
export NAME=vprofile.k8s.local        # or a Route53 subdomain you own
bash kops/create-cluster.sh
```
This takes about 15–20 minutes. Afterwards `kubectl get nodes -L topology.kubernetes.io/zone` should list 3 control-plane and 3 worker nodes across 3 zones.

## 3. Fill in the secret (locally, don't commit)

Edit `k8s/04-secret.yaml` and replace the `CHANGE_ME` values with strong passwords, e.g. from `openssl rand -base64 24`. To keep real values out of git:
```bash
git update-index --skip-worktree k8s/04-secret.yaml
```

## 4. Deploy

```bash
kubectl apply -f k8s/
```
The numbered files are applied in order: namespace → quota → config → secret → storage → DB → services → app → HPA/PDB → ingress → network policies. The app pods wait in `Init` until MySQL is up.

## 5. Verify

```bash
kubectl -n vprofile get pods -o wide             # app pods on 3 different zones, mysql-0 Running
kubectl -n vprofile get pvc                      # data-mysql-0 Bound
kubectl -n vprofile get hpa,pdb
kubectl -n vprofile describe resourcequota       # used vs hard
kubectl -n vprofile get ingress vprofile         # ADDRESS = ALB DNS name (wait 2–3 min)
```
Open `http://<ALB-DNS>/` and register a user to confirm DB writes.

**HA drills:**
- `kubectl -n vprofile delete pod -l app=vprofile-app --wait=false`: site stays up.
- `kubectl -n vprofile delete pod mysql-0`: the pod comes back with the same data.
- `kubectl drain <node> --ignore-daemonsets --delete-emptydir-data`: the PDB keeps 2+ app pods serving.
- `kops rolling-update cluster --name $NAME --yes --force`: nodes are replaced one by one.

---

## Application changes (ui-revamp)

**New UI.** Every page has been redesigned with a single self-contained stylesheet (`resources/css/app.css`) and an SVG icon sprite. There's no Bootstrap, no jQuery and no CDN, so the pages work offline. Each page uses shared `includes/head|nav|footer.jspf`. The footer shows the pod that served the request, which is useful for HA demos. The dashboard shows real profile data, a completeness meter and pod/runtime info. There's also a sectioned profile editor, a searchable user list, a photo upload with preview, and styled error pages.

**Bugs and security fixes:**
- Fixed: users couldn't log in after editing their profile, because the password hash was hashed again on every save. Profile edits now use the new `UserService.update()`.
- Every page except landing, login, sign-up, `/health` and static files now requires login. `/users`, `/rest/**`, RabbitMQ and Elasticsearch pages are admin-only (`admin_vp`).
- Users can only edit their own profile. The username can't be changed from the form.
- Photo upload uses the signed-in user (no longer a form field). The file name is generated by the server and the content is checked to be PNG/JPEG/GIF/WebP. Photos are served from `/profile/photo/{username}` and the size limit is now 2 MB.
- Plain-text passwords are no longer logged. User data is HTML-escaped in every page (`c:out`). Usernames are limited to letters, numbers, `.`, `_` and `-`. Email is validated.
- Added a public `/health` endpoint for probes and the ALB. It needs no session and doesn't query the database.
- Memcached is optional: with no host configured, caching is skipped quietly. Hibernate SQL logging is off.
- `application.properties` no longer contains `root/devopspassword`. Credentials come from env vars.

## Notes / follow-ups

- **Admin account:** admin pages are tied to the seeded `admin_vp` user. Its password isn't known, so set a new BCrypt hash for it in MySQL or change `ADMIN_USERNAME` and the rules in `appconfig-security.xml`.
- **Photos** are stored on the pod's local disk. With several replicas a photo is only on the pod that received it, and it's lost on restart. For production, mount shared storage and set `UPLOAD_DIR`, or move photos to S3.
- **RabbitMQ / Elasticsearch** aren't deployed, so those two admin demo pages will error.
- **Upgrading MySQL:** `mysql-connector-java 5.1.36` fails against MySQL 8.x. Bump it in `pom.xml` to `5.1.49` or later first.
- **Old files:** `manifests/`, `Docker-app/` can be deleted.
- **HTTPS:** request an ACM certificate and uncomment the HTTPS lines in `k8s/11-ingress.yaml`.
