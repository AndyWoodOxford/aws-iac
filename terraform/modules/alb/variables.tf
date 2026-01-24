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

