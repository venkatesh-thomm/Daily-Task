
output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.ec2.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.ec2.public_ip
}


output "ec2_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.ec2.public_dns
}

output "ec2_availability_zone" {
  description = "EC2 Availability Zone"
  value       = aws_instance.ec2.availability_zone
}


output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = aws_security_group.ec2-sg.id
}

