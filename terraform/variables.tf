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