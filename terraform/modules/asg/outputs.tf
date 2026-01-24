output "asg_name" {
  description = "Name of the ASG"
  value       = aws_autoscaling_group.this.name
}

output "instance_security_group_id" {
  description = "ID of the security group attached to the instances"
  value       = aws_security_group.this.id
}
