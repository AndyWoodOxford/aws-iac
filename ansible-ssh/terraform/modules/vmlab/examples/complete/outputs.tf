output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = module.vmlab.instances_ipv4
}

output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = module.vmlab.control_host
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vmlab.vpc_id
}