terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-state-eks"
    key            = "cluster/ap-southeast-2/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-up-and-running-locks-eks"
    encrypt        = true
  }
}

module "vpc" {
  source              = "./vpc"
  cidr                = "10.0.0.0/16"
  vpc_name            = var.vpc_name
  public_subnet_cidr  = ["10.0.204.0/22", "10.0.208.0/22", "10.0.212.0/22"]
  private_subnet_cidr = ["10.0.228.0/22", "10.0.232.0/22", "10.0.236.0/22"]
}

module "ecs" {
  source              = "./ecs"
  vpc_id              = module.vpc.vpc_id
  cluster_name        = var.cluster_name
  subnet_ids          = flatten([module.vpc.private_subnet])
  trusted_cidr_blocks = ["10.0.204.0/22", "10.0.208.0/22", "10.0.212.0/22"]
  tags = {
    Stack = "Dev"
  }
}

module "jumpbox" {
  source                  = "./jumpbox"
  instance_type           = var.instance_type
  instance_ami            = var.instance_ami
  server-name             = var.jumpbox_name
  aws_key_pair_name       = var.aws_key_pair_name
  aws_key_pair_public_key = var.aws_key_pair_public_key
  vpc_id                  = module.vpc.vpc_id
  k8-subnet               = module.vpc.public_subnet[0]
}