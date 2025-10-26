output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].private_ip
}

output "nat_gateway" {
  description = "NAT gateway id"
  value       = module.vpc.natgw_ids
}