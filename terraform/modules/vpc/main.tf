module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.18.1"

  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets


  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  # Ensure public subnets auto-assign public IPs
  map_public_ip_on_launch = true

}

