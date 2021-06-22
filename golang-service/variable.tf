variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "cluster_name" {
  description = "Cluster name."
}

variable "vpc_id" {
}

variable "private_subnet" {
  description = ""
}

variable "public_subnet" {
  description = ""
}

variable "trusted_cidr_blocks" {
  description = "Trusted subnets e.g. with ALB and bastion host."
  type        = list(string)
  default     = [""]
}