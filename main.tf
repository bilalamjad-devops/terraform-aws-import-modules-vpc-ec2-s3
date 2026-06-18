# main.tf
# This file defines the overall Terraform configuration and calls the modules.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible AWS provider version
    }
  }
}

provider "aws" {
  region = var.aws_region # AWS region for deploying resources
}

# Module for VPC and core networking components (subnet, IGW, RT)
# This module also manages the VPC's default security group internally.
module "vpc" {
  source = "./modules/vpc" # Path to the VPC module

  # Pass configuration variables from root to the VPC module
  vpc_cidr          = var.vpc_cidr
  vpc_name          = var.vpc_name
  subnet_cidr       = var.subnet_cidr
  subnet_name       = var.subnet_name
  availability_zone = var.availability_zone
  igw_name          = var.igw_name
  rt_name           = var.rt_name
}

# Module for EC2 instance
# This module also manages its associated custom security group internally.
module "ec2" {
  source        = "./modules/ec2" # Path to the EC2 module

  # Pass configuration variables from root to the EC2 module
  ami           = var.ami
  instance_type = var.instance_type
  instance_name = var.instance_name

  # Get required IDs from the VPC module's output
  subnet_id = module.vpc.public_subnet_id
  vpc_id    = module.vpc.vpc_id # Pass VPC ID to EC2 module for SG creation

  # Pass custom security group details
  ec2_sg_name        = var.ec2_sg_name
  ec2_sg_description = var.ec2_sg_description
}

# Module for S3 bucket
module "s3" {
  source      = "./modules/s3" # Path to the S3 module
  bucket_name = var.bucket_name # Pass the bucket name from root to S3 module
}
