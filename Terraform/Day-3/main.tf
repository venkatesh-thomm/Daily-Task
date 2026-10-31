


module "ec2_instance" {
  source        = "./modules/ec2"
  instance_name = "instance"
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  environment   = var.environment

  common_tags = local.common_tags
}
