# variables.tf
# This file declares input variables for the root Terraform configuration.

variable "aws_region" {
  description = "The AWS region where resources will be deployed."
  type        = string
  default     = "ap-south-1" # Default region
}

# VPC variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}
variable "vpc_name" {
  description = "The name tag for the VPC."
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet."
  type        = string
}
variable "subnet_name" {
  description = "The name tag for the public subnet."
  type        = string
}
variable "availability_zone" {
  description = "The Availability Zone for the public subnet."
  type        = string
}

variable "igw_name" {
  description = "The name tag for the Internet Gateway."
  type        = string
}

variable "rt_name" {
  description = "The name tag for the public Route Table."
  type        = string
}

# EC2 variables
variable "ami" {
  description = "The AMI ID for the EC2 instance."
  type        = string
}
variable "instance_type" {
  description = "The instance type for the EC2 instance."
  type        = string
}
variable "instance_name" {
  description = "The name tag for the EC2 instance."
  type        = string
}

# Custom Security Group variables (for EC2 module)
variable "ec2_sg_name" {
  description = "The name for the EC2 security group."
  type        = string
}
variable "ec2_sg_description" {
  description = "The description for the EC2 security group."
  type        = string
  default     = "Security group for EC2 instance"
}

# S3 variables
variable "bucket_name" {
  description = "The globally unique name for the S3 bucket."
  type        = string
}
