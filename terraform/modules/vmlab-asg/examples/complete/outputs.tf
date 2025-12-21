output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = module.vmlab.control_host
}

output "lb_endpoint" {
  description = "DNS name of the load balancer"
  value       = module.vmlab.lb_dns_name
}

output "app_endpoint" {
  description = "Application endpoint"
  value       = "http://${module.vmlab.lb_dns_name}/"
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vmlab.vpc_id
}
