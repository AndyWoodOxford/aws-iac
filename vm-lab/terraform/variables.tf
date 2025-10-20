# General
variable "name_prefix" {
  type        = string
  description = "Use this as a prefix for the Name tags on resources"
  validation {
    condition     = var.name_prefix == lower(var.name_prefix)
    error_message = "The resources cannot have upper case characters."
  }
  default = "vmlab"
}

# EC2
variable "public_key_path" {
  type        = string
  description = "Path to the SSH public key file used to launch instances"
  default     = "~/.ssh/id_rsa.pub"
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
  default     = 1
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
