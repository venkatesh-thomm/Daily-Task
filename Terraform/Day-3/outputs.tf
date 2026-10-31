
output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_port" {
  value = module.rds.db_port
}


output "ec2_instance_id" {
  value = module.ec2_instance.ec2_instance_id
}

output "ec2_public_ip" {
  value = module.ec2_instance.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.ec2_instance.ec2_public_dns
}

output "ec2_availability_zone" {
  value = module.ec2_instance.ec2_availability_zone
}


output "security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.ec2_instance.ec2_security_group_id
}



###Remember the difference:
#- Child outputs.tf → Exposes values from AWS resources.
#- Root outputs.tf → Exposes values returned by child modules.
