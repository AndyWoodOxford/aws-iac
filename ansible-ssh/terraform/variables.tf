# General
variable "environment" {
  type        = string
  description = "The name of the environment, e.g. 'dev', 'example01'"
  default     = "example"
}

variable "name" {
  type        = string
  description = "All resources will use this lowercase var as a Name, or as a prefix to the Name"
  default     = "vmlab"
}

# EC2
variable "platform" {
  type        = string
  description = "EC2 VM platform"
  default     = "ubuntu"
}

variable "instance_type" {
  type        = string
  description = "Type of the EC2 instance"
  default     = "t2.micro"
}

variable "instance_count" {
  type        = number
  description = "Number of instances"
  default     = 2
}

variable "public_key_path" {
  type        = string
  description = "Path to the SSH public key file used to launch the instances"
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the non-default VPC"
  default     = "10.10.0.0/16"
}

variable "subnet_cidr_mask" {
  type        = number
  description = "CIDR mask, e.g. /27 gives 27 (32 - 5)usable addresses"
  default     = 27
}
