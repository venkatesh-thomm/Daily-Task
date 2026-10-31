module "ec2_instance" {
  source = "./modules/ec2"

  environment   = var.environment
  instance_name = var.instance_name
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  common_tags   = var.common_tags
}


module "rds" {
  source                = "./modules/rds"
  environment           = var.environment
  instance_name         = var.rds_instance_name
  instance_class        = var.rds_instance_class
  engine                = var.rds_engine
  engine_version        = var.rds_engine_version
  db_username           = var.rds_db_username
  db_password           = var.rds_db_password
  ec2_security_group_id = module.ec2_instance.ec2_security_group_id
  common_tags           = var.common_tags
}
