variable "vpc_id" {
}

variable "cluster_name" {
  description = "Cluster name."
}

variable "tags" {
  description = "Tags."
  type        = map(string)
}

variable "subnet_ids" {
  description = ""
}

variable "spot" {
  description = "Choose should we use spot instances or on-demand to poulate ECS cluster."
  type        = bool
  default     = false
}

variable "instance_types" {
  description = "ECS node instance types. Maps of pairs like `type = weight`. Where weight gives the instance type a proportional weight to other instance types."
  type        = map(any)
  default = {
    "t3a.small" = 1
  }
}

variable "ami_id" {
  default = "ami-05d4d52c00993475d"
}

variable "security_group_ids" {
  description = "Additional security group IDs. Default security group would be merged with the provided list."
  default     = []
}

variable "trusted_cidr_blocks" {
  description = "Trusted subnets e.g. with ALB and bastion host."
  type        = list(string)
  default     = [""]
}

variable "aws_key_pair_name" {
  description = "AWS Key Pair Name of the EC2 Instance"
  default     = "stevejc-ec2-ecs-test-key-pair"
}

variable "aws_key_pair_public_key" {
  description = "AWS Key Pair Public Key of the EC2 Instance"
  default     = "~/.ssh/stevejc-ec2-test-key-pair.pub"
}