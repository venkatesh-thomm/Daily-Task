
# Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "ec2_server_a_id" {
  value = aws_instance.server_a.id
}

output "ec2_server_b_id" {
  value = aws_instance.server_b.id
}


output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
