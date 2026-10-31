# Environment configuration
environment = "dev"

# EC2 configuration
instance_name = "bastion"
instance_type = "t3.micro"

subnet_id = "subnet-0cae11c3f3520d034"


# Common tags
common_tags = {
  Project     = "Terraform-Drift-Lab"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "DevOps"
}
