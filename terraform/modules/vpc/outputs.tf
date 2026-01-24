output "vpc_id" {
  description = "VPC id"
  value       = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = var.create_vpc ? module.vpc[0].public_subnets : data.aws_subnets.default.ids
}