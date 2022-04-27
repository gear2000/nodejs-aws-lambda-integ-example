variable "product" {
  type        = string
  default     = "apigateway"
}

variable "aws_default_region" {
  type        = string
  default     = "eu-west-1"
}

variable "cloud_tags" {
  description = "additional tags as a map"
  type        = map(string)
  default     = {}
}

variable "apigateway_name" {
  type        = string
}

variable "lambda_name" {
  type        = string
}

variable "lambda_arn" {
  type        = string
}

variable "stage_name" {
  type        = string
  default     = "dev"
}

variable "http_method" {
  type        = string
  default     = "POST"
}

