module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  availability_zone     = var.availability_zone
  availability_zone_2   = "ap-south-1b"
  public_subnet_2_cidr  = "10.0.3.0/24"
  private_subnet_2_cidr = "10.0.4.0/24"


}

module "security_group" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
}

module "eks" {
  source = "./modules/eks"

  subnet_ids = [
    module.vpc.public_subnet_id,
    module.vpc.private_subnet_id,
    module.vpc.public_subnet_2_id,
    module.vpc.private_subnet_2_id
  ]
  node_subnet_ids = [
    module.vpc.public_subnet_id,
    module.vpc.public_subnet_2_id
  ]
}