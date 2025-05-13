# EC2
variable "public_key_path" {
  type        = string
  description = "Path to the SSH public key file used to launch instances"
  default     = "~/.ssh/id_rsa.pub"
}