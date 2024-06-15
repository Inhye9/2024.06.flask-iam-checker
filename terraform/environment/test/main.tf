provider "aws" {
  region = var.region
}

# vpc 
module "vpc" {
  source = "../../modules/vpc"
  vpc_id       = var.vpc_id
  name         = var.name
}

# ec2
module "ec2" {
  source = "../../modules/ec2"
  region            = var.region
  subnet_id         = var.subnet_id
  name              = var.name
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  instance_profile_role = module.iam.ec2_ssm_instance_profile_role
  security_group_id = module.vpc.aws_security_group_id
}

# iam
module "iam" {
  source = "../../modules/iam"
  vpc_id             = var.vpc_id
  name              = var.name
}

