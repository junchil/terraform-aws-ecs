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