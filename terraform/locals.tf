locals {

  aws_account_id = "897722689734"
  prefix         = "mrdevops"
  region          = "us-east-1"
  environment     = "dev"
  cluster_name    = "${local.prefix}-${local.environment}-eks"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    Name = "${local.prefix}-${local.environment}"
    Environment = "${ local.environment}"
  }

}