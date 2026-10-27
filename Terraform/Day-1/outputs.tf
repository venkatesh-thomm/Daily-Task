
# Outputs
output "vpc_id" {
  value = aws_vpc.lab.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "server_a_id" {
  value = aws_instance.server_a.id
}

output "server_b_id" {
  value = aws_instance.server_b.id
}
