# modules/vpc/variables.tf
# This file declares input variables specific to the VPC module.

variable "vpc_cidr" {
  type = string
}
variable "vpc_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "availability_zone" {
  type = string
}

variable "igw_name" {
  type = string
}

variable "rt_name" {
  type = string
}
