variable "name" {
  type        = string
  description = "All resources will use this as a Name, or as a prefix to the Name"
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The resources cannot have upper case characters."
  }
  default = "CHANGEME"
}

variable "tags" {
  type        = map(string)
  description = "Add these tags to all resources"
  default     = {}
}

variable "create_vpc" {
  type        = bool
  description = "Create a VPC if true. Use the default VPC if false."
  default     = "false"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the non-default VPC"
  default     = "192.168.0.0/16"
}

variable "subnet_cidr_mask" {
  type        = number
  description = "CIDR mask, e.g. /28 gives 11 (16 - 5) usable addresses"
  validation {
    condition     = var.subnet_cidr_mask >= 16 && var.subnet_cidr_mask <= 28
    error_message = "The CIDR subnet mask must be in the range 16 to 28."
  }
  default = 28
}


