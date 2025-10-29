output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].private_ip
}

output "nat_gateway" {
  description = "NAT gateway id"
  value       = module
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}