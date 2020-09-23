variable "region" {
  default = "ap-southeast-2"
}

variable "vpc_name" {
  description = "VPC name"
  default     = "ecsec2test"
}

variable "cluster_name" {
  description = "Cluster name."
  default     = "app"
}

variable "aws_key_pair_name" {
  description = "AWS Key Pair Name of the EC2 Instance"
  default     = "stevejc-ec2-test-key-pair"
}

variable "aws_key_pair_public_key" {
  description = "AWS Key Pair Public Key of the EC2 Instance"
  default     = "~/.ssh/stevejc-ec2-test-key-pair.pub"
}

variable "instance_ami" {
  default = "ami-08fdde86b93accf1c"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "jumpbox_name" {
  description = "jumpbox ec2 server Name"
  default     = "jumpbox"
}