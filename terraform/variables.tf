# EC2
variable "ami_amazon_linux" {
  type        = map(string)
  description = "ID for latest Amazon Linux AMI"
  default = {
    eu-west-2 = "ami-0dfe0f1abee59c78d"
  }
}

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