variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "The target deployment environment (e.g., dev, staging, prod)"
  type        = string
}



variable "common_tags" {
  description = "A map of common tags to assign to the resource"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Owner       = "DevOps"
  }
}


variable "tags" {
  description = "A map of base tags to assign to the resource"
  type        = map(string)
  default = {
    Project = "MyAwesomeApp"
  }
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
