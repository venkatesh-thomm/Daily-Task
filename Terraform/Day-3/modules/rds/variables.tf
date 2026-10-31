variable "instance_name" {
  description = "Name of the RDS instance"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "5.7"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.t3.micro"
}



variable "environment" {
  description = "The target deployment environment (e.g., dev, staging, prod)"
  type        = string
}



variable "common_tags" {
  description = "A map of common tags to assign to the resource"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Owner     = "DevOps"
  }
}


variable "tags" {
  description = "A map of base tags to assign to the resource"
  type        = map(string)
  default = {
    Project = "MyAwesomeApp"
  }
}


variable "subnet_id" {
  type        = string
  description = "The subnet ID to deploy resources into"
  default     = null # This makes it optional
}


variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "ec2_security_group_id" {
  description = "EC2 Security Group ID allowed to access RDS"
  type        = string
}

