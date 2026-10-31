# Environment configuration
environment = "staging"

# EC2 configuration
instance_name = "bastion"
instance_type = "t3.micro"

# public subnet ID for the bastion host
subnet_id = "subnet-0ad3a786fedff2a06"



# RDS configuration
rds_instance_name  = "mydb"
rds_engine         = "mysql"
rds_engine_version = "5.7"
rds_instance_class = "db.t3.micro"
rds_db_username    = "admin"
rds_db_password    = "Password123!"


# Common tags
common_tags = {
  Project     = "Terraform-Drift-Lab"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "DevOps"
}
