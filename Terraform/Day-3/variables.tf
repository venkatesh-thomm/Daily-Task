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