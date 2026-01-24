output "vpc_id" {
  description = "VPC id"
  value       = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}
