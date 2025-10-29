output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = module.resources.instances_ipv4
}

output "control_host" {
  description = "IPV4 of the control host (whitelisted on port 22)"
  value       = module.resources.control_host
}