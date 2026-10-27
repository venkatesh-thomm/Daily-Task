

# Find available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the latest Amazon Linux 2023 AMI ID
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-drift-lab-vpc"
  }

}

# 2. Create Subnet-A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-a"
  }

}

# 3. Create Subnet-B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-b"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-route-table"
  }
}

# aws_route_table_association does not support tags in Terraform
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public.id

}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private-route-table"
  }
}



resource "aws_route_table_association" "subnet_b_public" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public.id
}

## internet gateway 
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-drift-lab-gw"
  }
}


resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}



# 5. Create EC2 in Subnet-A
resource "aws_instance" "server_a" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.lab.id]
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>Hello from Server A</h1>" > /var/www/html/index.html
  EOF
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
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>Hello from Server B</h1>" > /var/www/html/index.html
  EOF
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
