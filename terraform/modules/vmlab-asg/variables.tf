variable "name" {
  type        = string
  description = "All resources will use this as a Name, or as a prefix to the Name"
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The resources cannot have upper case characters."
  }
  default = "vmlab"
}

variable "tags" {
  type        = map(string)
  description = "Add these tags to all resources"
  default     = {}
}

### EC2
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

### VPC
variable "create_vpc" {
  type        = bool
  description = "Create a VPC if true. Use the default VPC if false."
  default     = "false"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the non-default VPC"
  validation {
    condition     = var.vpc_cidr >= 16 && var.vpc_cidr <= 28
    error_message = "The VPC CIDR must be in the range 16 to 28."
  }
  default = "192.168.255.0/24"
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

variable "control_host_ingress" {
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
  }))
  description = "Ingress from control host"
  validation {
    condition = alltrue(
      [for i in var.control_host_ingress : contains(["icmp", "tcp", "udp"], i.protocol)]
    )
    error_message = "One of the protocol(s) is not supported."
  }
  default = []
}
