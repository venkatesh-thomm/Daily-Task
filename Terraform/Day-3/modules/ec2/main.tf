
# 1. Fetch existing default VPC
data "aws_vpc" "default" {
  default = true
}


# Get the latest Amazon Linux 2023 AMI ID
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}


# 4. Security group for EC2 instances
resource "aws_security_group" "ec2-sg" {
  name        = "${var.environment}-ec2-sg"
  description = "Security group for Terraform drift lab"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ec2-sg"
    }
  )

}



resource "aws_instance" "ec2" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  user_data                   = <<-EOF
    #!/bin/bash
    dnf install -y httpd
    systemctl enable --now httpd
    echo "<h1>Hello from Server B</h1>" > /var/www/html/index.html
  EOF
  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.instance_name}-ec2"
    }
  )
}
