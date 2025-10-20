output "ami_id" {
  description = "ID of AMI used for instance(s)"
  value       = data.aws_ami.amazon_linux.id
}

output "ami_name" {
  description = "Name of AMI used for instance(s)"
  value       = data.aws_ami.amazon_linux.name
}

output "instances_ipv4" {
  description = "IPV4 addresses of the instance(s)"
  value       = aws_instance.vm[*].public_ip
}