output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = local.control_host
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.vmlab.dns_name
}

output "nat_gateway" {
  description = "NAT gateway id"
  value       = var.create_vpc ? module.vpc[0].natgw_ids : null
}

output "vpc_id" {
  description = "VPC id"
  value       = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}
