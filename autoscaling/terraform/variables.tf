variable "resource_prefix" {
  type        = string
  description = "Use this as a prefix for the Name tags on resources"
  validation {
    condition     = var.resource_prefix == lower(var.resource_prefix)
    error_message = "The resources cannot have upper case characters."
  }
  default = "example"
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

variable "desired_capacity" {
  type        = number
  description = "Desired capacity of the auto-scaling group"
  validation {
    condition     = var.desired_capacity <= 3
    error_message = "No more that 3 instances can be running."
  }
  default = 2
}
