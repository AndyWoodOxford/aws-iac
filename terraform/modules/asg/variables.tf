variable "name" {
  type        = string
  description = "All resources will use this as a Name, or as a prefix to the Name"
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The resources cannot have upper case characters."
  }
  default = "asg"
}

variable "tags" {
  type        = map(string)
  description = "Add these tags to all resources"
  default     = {}
}

variable "platform" {
  type        = string
  description = "EC2 VM platform"
  validation {
    condition     = contains(["amazonlinux", "debian", "ubuntu"], var.platform)
    error_message = "Unsupported platform."
  }
  default = "ubuntu"
}

variable "instance_type" {
  type        = string
  description = "Type of the EC2 instance"
  default     = "t2.micro"
  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Only free-tier instances can be spun up."
  }
}

variable "userdata" {
  type        = string
  description = "Path to a file containing EC2 userdata (plain text)."
  default     = null
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in the ASG"
  validation {
    condition     = var.asg_max_size <= local.asg_max_size
    error_message = <<-EOT
    The Autoscaling Group can contain a maximum of ${local.asg_max_size} instances!

    This Terraform plan will include up to ${var.asg_max_size} instances which could
    result in an unpleasant AWS bill.
    EOT
  }
  default = 1
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in the ASG."
  default     = 1
}

variable "subnet_ids" {
  description = "ASG will be deployed into these subnets"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Register the instances in these ELB target groups"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "The health check type must be one of 'EC2', 'ELB'."
  }
  default = "EC2"
}
