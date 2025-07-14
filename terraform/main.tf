module "vpc" {
  source = "./modules/vpc"
  vpc_name = "${local.prefix}-${local.environment}-vpc"
  vpc_cidr = local.vpc_cidr
  azs = local.azs
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets 
}

module "key_pair" {
  source = "./modules/key_pair"
  key_name = local.key_name
}

module "EC2" {
  source = "./modules/ec2"
  key_name = module.key_pair.key_name
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  ami_id = data.aws_ami.os_image.id
}

module "bastion_host" {
  source = "./modules/bastion_host"
  key_name = module.key_pair.key_name
  instance_type = var.instance_type
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  ami_id = data.aws_ami.os_image.id
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = local.cluster_name
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  private_subnets  = module.vpc.private_subnets
  key_name         = module.key_pair.key_name
  tags             = local.tags
}