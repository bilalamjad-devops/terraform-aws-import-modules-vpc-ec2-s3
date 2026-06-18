# modules/vpc/vpc.tf
# This file defines the VPC and its core networking components, including the default security group.

resource "aws_vpc" "imported_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "imported_subnet" {
  vpc_id                  = aws_vpc.imported_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # Set to TRUE to match manual creation (Auto-assign public IP: Enabled)

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "imported_igw" {
  vpc_id = aws_vpc.imported_vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "imported_rt" {
  vpc_id = aws_vpc.imported_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.imported_igw.id
  }

  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "imported_rta" {
  subnet_id      = aws_subnet.imported_subnet.id
  route_table_id = aws_route_table.imported_rt.id
}

# Manage the default security group for this VPC
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.imported_vpc.id # Reference the VPC created within this same module

  # No ingress/egress blocks here to match AWS default behavior (all outbound, no inbound)
  # If you manually changed default SG rules, you'd define them here to match.
}
