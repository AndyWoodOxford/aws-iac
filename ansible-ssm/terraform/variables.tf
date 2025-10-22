# General
variable "environment" {
  type        = string
  description = "The name of the environment, e.g. 'dev', 'example01'"
  validation {
    condition     = length(var.environment) <= 12
    error_message = "The maximum length of the 'environment_name' variable is 12 characters."
  }
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.environment))
    error_message = "The 'environment_name' variable can contain only lower case letters or numbers."
  }
  default = "wip"
}

variable "name" {
  type        = string
  description = "All resources will use this as a Name, or as a prefix to the Name"
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The resources cannot have upper case characters."
  }
  default = "vmlab"
}

# EC2
variable "platform" {
  type        = string
  description = "EC2 VM platform"
  validation {
    condition     = contains(["amazonlinux2", "ubuntu"], var.platform)
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

variable "instance_count" {
  type        = number
  description = "Number of instances"
  default     = 2
  validation {
    condition     = var.instance_count <= 5
    error_message = "No more than 5 instances can be launched."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the non-default VPC"
  default     = "10.10.0.0/16"
}

variable "subnet_cidr_mask" {
  type        = number
  description = "CIDR mask, e.g. /27 gives 27 (32 - 5)usable addresses"
  validation {
    condition     = var.subnet_cidr_mask > 16 && var.subnet_cidr_mask <= 28
    error_message = "The CIDR subnet mask must be in the range 17 to 28."
  }
  default = 27
}
