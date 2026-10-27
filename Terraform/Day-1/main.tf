

# Find available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the latest Amazon Linux 2023 AMI ID
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 1. Create VPC
resource "aws_vpc" "lab" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-drift-lab-vpc"
  }

}

# 2. Create Subnet-A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-a"
  }

}

# 3. Create Subnet-B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-b"
  }

}

# 4. Security group - no inbound access
resource "aws_security_group" "lab" {
  name        = "terraform-drift-lab-sg"
  description = "Security group for Terraform drift lab"
  vpc_id      = aws_vpc.lab.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-drift-lab-sg"
  }

}

# 5. Create EC2 in Subnet-A
resource "aws_instance" "server_a" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.lab.id]
  associate_public_ip_address = false

  tags = {
    Name        = "server-subnet-a"
    Environment = "lab"
  }

  lifecycle {
    prevent_destroy = true

    # Ignore manual changes to the instance type
    ignore_changes = [
      instance_type,
    ]
  }
}

# 6. Create EC2 in Subnet-B
resource "aws_instance" "server_b" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_b.id
  vpc_security_group_ids      = [aws_security_group.lab.id]
  associate_public_ip_address = false

  tags = {
    Name        = "server-subnet-b"
    Environment = "lab"
  }

  lifecycle {
    prevent_destroy = true

    # Ignore manual changes to the instance type
    ignore_changes = [
      instance_type,
      tags

    ]
  }
}
