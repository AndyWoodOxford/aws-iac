output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = local.control_host
}

output "control_host_ingress" {
  description = "Ingress allowed from the control host"
  value       = var.control_host_ingress
}

output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].public_ip
}

output "nat_gateway" {
  description = "NAT gateway id"
  value       = var.create_vpc ? module.vpc[0].natgw_ids : null
}

output "vpc_id" {
  description = "VPC id"
  value       = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}
