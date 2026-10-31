

resource "aws_db_instance" "default" {

  identifier     = "${var.environment}-${var.instance_name}"
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  username = var.db_username
  password = var.db_password

  publicly_accessible = false

  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  tags = merge(var.common_tags, {
    Name     = var.instance_name
    Resource = "RDS-Instance"
  })
}


# 1. Fetch existing default VPC
data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "rds-sg" {
  name        = "${var.environment}-rds-sg"
  description = "Security group for RDS"

  vpc_id = data.aws_vpc.default.id

  ingress {
    description     = "Allow MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.environment}-rds-sg"
  })
}


resource "aws_db_subnet_group" "main" {
  name        = "${var.environment}-rds-subnet-group"
  description = "Private subnet group for RDS"

  subnet_ids = [
    "subnet-0a0c7080a3ad24c29",
    "subnet-04c08c11d1024a89a"
  ]

  tags = merge(var.common_tags, {
    Name = "${var.environment}-rds-subnet-group"
  })
}
