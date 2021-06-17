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

module "cluster" {
  source              = "./cluster"
  vpc_id              = module.vpc.vpc_id
  cluster_name        = var.cluster_name
  subnet_ids          = flatten([module.vpc.private_subnet])
  trusted_cidr_blocks = flatten([module.vpc.public_subnet])
  tags = {
    Stack = "Dev"
  }
}