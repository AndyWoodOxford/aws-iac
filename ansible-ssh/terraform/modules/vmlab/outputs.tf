output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].public_ip
}

output "nat_gateway" {
  description = "NAT gateway id"
  value       = module.vpc.natgw_ids
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = local.control_host
}