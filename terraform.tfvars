# terraform.tfvars
# This file provides default values for the root variables.
# ENSURE THESE VALUES EXACTLY MATCH YOUR MANUALLY CREATED AWS RESOURCES.

# VPC Configuration
vpc_cidr          = "10.0.0.0/16"
vpc_name          = "My-VPC"
subnet_cidr       = "10.0.1.0/24"
subnet_name       = "Public-subnet-a"
availability_zone = "ap-south-1a" # Make sure this matches your manual AZ
igw_name          = "My-internet-gateway"
rt_name           = "Public-route-table-a"

# EC2 Configuration
ami           = "ami-0d03cb826412c6b0f" # 👈 Use a valid AMI for your region (e.g., Amazon Linux 2023)
instance_type = "t2.micro"
instance_name = "My-EC2"

# Custom Security Group values (for EC2 module)
# These names/descriptions should match what you manually created for My-EC2-SG
ec2_sg_name        = "My-EC2-SG"
ec2_sg_description = "Security group for My-EC2 instance"

# S3 Configuration
bucket_name = "my-existing-s3-bucket-name-08-july-2025" # MUST be globally unique and match your manual bucket name
