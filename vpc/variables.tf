#VPC
variable "create_vpc" {
  default = " "
}

variable "vpc_name" {
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

#subnet variable
variable "public_subnet_cidr" {
  description = "Public CIDR"
  type        = list(string)
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private CIDR"
  default     = []
}

