output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = module.vmlab.control_host
}

output "control_host_access" {
  description = "Ingress on the instances from the control host"
  value       = module.vmlab.control_host_ingress
}

output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = module.vmlab.instances_ipv4
}

output "vpc_id" {
  description = "VPC id"
  value       = module.vmlab.vpc_id
}
