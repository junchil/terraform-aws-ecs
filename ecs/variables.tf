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

variable "protect_from_scale_in" {
  description = "The autoscaling group will not select instances with this setting for termination during scale in events."
  default     = true
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
    "t3a.small" = 2
  }
}

variable "ami_id" {
  default = "ami-08fdde86b93accf1c"
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

variable "target_capacity" {
  description = "The target utilization for the cluster. A number between 1 and 100."
  default     = "10"
}

variable "aws_key_pair_name" {
  description = "AWS Key Pair Name of the EC2 Instance"
  default     = "stevejc-ec2-ecs-test-key-pair"
}

variable "aws_key_pair_public_key" {
  description = "AWS Key Pair Public Key of the EC2 Instance"
  default     = "~/.ssh/stevejc-ec2-test-key-pair.pub"
}