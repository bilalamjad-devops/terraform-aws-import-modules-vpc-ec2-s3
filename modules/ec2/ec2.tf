# modules/ec2/ec2.tf
# This file defines the EC2 instance and its associated custom security group.

# Custom Security Group for the EC2 instance
resource "aws_security_group" "custom_sg" {
  name        = var.ec2_sg_name
  description = var.ec2_sg_description
  vpc_id      = var.vpc_id # VPC ID passed from root module

  # Add ingress rules to match your manual creation (e.g., SSH from anywhere)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (adjust as needed)
  }

  # Default egress rule (all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {} # Keep this empty tags block to match the default imported state of manually created SGs
}

resource "aws_instance" "imported_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true # Matches subnet auto-assign setting

  # Attach the custom security group created within this same module
  vpc_security_group_ids = [aws_security_group.custom_sg.id]

  tags = {
    Name = var.instance_name
  }
}
