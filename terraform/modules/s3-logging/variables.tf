variable "create_bucket" {
  type        = bool
  description = "Create the bucket if, and only if, this is true"
  default     = true
}

variable "name" {
  type        = string
  description = "Name of the bucket. If omitted, Terraform will assign a random name."
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The name can only have lower case characters."
  }
  default = null
}

variable "tags" {
  type        = map(string)
  description = "Add these tags to all resources"
  default     = {}
}

variable "expiry_in_days" {
  type        = number
  description = "Objects expire after this many days"
  default     = 7
}

variable "sse_key_arn" {
  type        = string
  description = "ARN for the (optional) KMS SSE encryption key"
  default     = null
}