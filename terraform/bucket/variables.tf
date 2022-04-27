variable "bucket" { default = "test46523463262" }
variable "aws_default_region" { default = "us-east-1" }

variable "enable_lifecycle" { default = false }
variable "expire_days" { default = null }
variable "noncurrent_version_expiration" { default = null }

variable "acl" { default = "private" }
variable "versioning" { default = null }
variable "force_destroy" { default = null }

variable "cloud_tags" {
  description = "additional tags as a map"
  type        = map(string)
  default     = {}
}
