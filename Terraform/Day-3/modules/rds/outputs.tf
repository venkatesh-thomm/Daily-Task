# RDS Instance ID
output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.default.id
}

# RDS Endpoint
output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = aws_db_instance.default.endpoint
}

# RDS Address
output "db_address" {
  description = "RDS hostname"
  value       = aws_db_instance.default.address
}

# RDS Port
output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.default.port
}

# RDS ARN
output "db_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.default.arn
}

# RDS Availability Zone
output "db_availability_zone" {
  description = "RDS Availability Zone"
  value       = aws_db_instance.default.availability_zone
}
