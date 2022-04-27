variable "project" {
  description = "Project name for tags and resource naming"
  default     = "nodejs-demo"
}

# VPC
variable vpc_cidr {
  description = "VPC CIDR"
  default             = "10.0.0.0/16"
}

variable igw_cidr {
  description = "VPC Internet Gateway CIDR"
  default             = "10.0.8.0/24"
}

variable public_subnets_cidr {
  description = "Public Subnets CIDR"
  type        = "list"
  default  = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable private_subnets_cidr {
  description = "Private Subnets CIDR"
  type        = "list"
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable azs {
  description = "VPC Availability Zones"
  type        = "list"
  default     = ["us-east-1a", "us-east-1b"]
}

# Lambda
variable "lambda_runtime" {
  description = "Lambda Function runtime"
  default     = "nodejs12.x"
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  default     = "nodejs-api-express"
}

variable "lambda_handler" {
  description = "Lambda Function Handler"
  default     = "lambda.handler"
}

variable "lambda_memory" {
  description = "Lambda memory size"
  default = "128"
}

variable "s3_bucket" {
  description = "s3 bucket for lambda function"
  default = "nodejs-demo-567901"
}

variable "s3_key" {
  description = "s3 key for lambda function"
  default = "nodejs-api-express.zip"
}

# API Gateway
variable "aws_default_region" {
  description = "Region in which to deploy the API"
  default = "us-east-1"
}

variable "stage_name" {
  description = "Stage Name for Api Gateway"
  default = "api"
}
