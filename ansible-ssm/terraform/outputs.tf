output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].public_ip
}