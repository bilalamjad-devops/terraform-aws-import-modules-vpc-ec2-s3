# modules/vpc/outputs.tf
# This file defines outputs from the VPC module, making resource IDs available to other modules.

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.imported_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet."
  value       = aws_subnet.imported_subnet.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.imported_igw.id
}

output "route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.imported_rt.id
}
