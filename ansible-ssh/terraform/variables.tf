# General
variable "environment" {
  type        = string
  description = "The name of the environment, e.g. 'dev', 'example01'"
  default     = "example"
}

# EC2
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
