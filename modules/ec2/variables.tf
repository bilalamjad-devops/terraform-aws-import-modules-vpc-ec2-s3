# modules/ec2/variables.tf
# This file declares input variables specific to the EC2 module.

variable "ami" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "instance_name" {
  type = string
}
variable "vpc_id" { # New variable to receive VPC ID for SG creation
  type = string
}
variable "ec2_sg_name" { # New variable for custom SG name
  type = string
}
variable "ec2_sg_description" { # New variable for custom SG description
  type = string
}
