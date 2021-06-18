terraform {
  backend "s3" {
    bucket         = "terraform-up-and-running-state-eks"
    key            = "cluster/ap-southeast-2/terraform-aws-ecs/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-up-and-running-locks-eks"
    encrypt        = true
  }
}