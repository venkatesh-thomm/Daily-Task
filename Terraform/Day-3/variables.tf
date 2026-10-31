
#### EC2 Variables ####

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "MyAwesomeApp"
}

variable "tags" {
  description = "Base tags"
  type        = map(string)

  default = {
    Project = "MyAwesomeApp"
  }
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)

  default = {
    ManagedBy = "Terraform"
    Owner     = "DevOps"
  }
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "my-ec2-instance"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID to deploy resources into"
  default     = null # This makes it optional
}



#### RDS Variables ####

variable "rds_db_username" {
  description = "The username for the database"
  type        = string
}

variable "rds_db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "rds_instance_name" {
  description = "Name of the RDS instance"
  type        = string
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "5.7"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

