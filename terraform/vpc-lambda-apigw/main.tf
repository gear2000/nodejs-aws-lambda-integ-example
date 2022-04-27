data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_default_region
}

# VPC
module "vpc_subnets" {
  name                 = "${var.project}-vpc"
  source               = "./modules/vpc"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnets_cidr  = "${var.public_subnets_cidr}"
  private_subnets_cidr = "${var.private_subnets_cidr}"
  igw_cidr             = "${var.igw_cidr}"
  azs                  = "${var.azs}"
  project              = "${var.project}"
}

resource "aws_security_group" "port3000" {

  vpc_id = "${module.vpc_subnets.vpc_id}"

  ingress {
    description = "port3000"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = "${var.project}"
    managed_by  = "terraform"
    Name        = "${var.project}-port3000-sg"
  }
}

resource "aws_security_group" "all" {

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${module.vpc_subnets.vpc_id}"

  tags = {
    Project     = "${var.project}"
    managed_by  = "terraform"
    Name        = "${var.project}-all-sg"
  }
}

# Lambda
module "lambda" {
  source        = "./modules/lambda"
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn
  memory        = var.lambda_memory

  subnet_ids         = module.vpc_subnets.public_subnet_ids
  security_group_ids = ["${aws_security_group.port3000.id}"]
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.project}-${var.lambda_function_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "vpc" {
  name = "${aws_iam_role.lambda_role.name}-vpc"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "logs" {
  name = "${aws_iam_role.lambda_role.name}-logs"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# API
module "api" {
  apigateway_name       = "${module.lambda.name}"
  source                = "./modules/api"
  http_method           = "GET"
  lambda_name           = "${module.lambda.name}"
  lambda_arn            = "${module.lambda.arn}"
  aws_default_region    = "${var.aws_default_region}"
  stage_name            = var.stage_name
}

# API v.2
#module "apiv2" {
#  apigateway_name       = "${module.lambda.name}"
#  source                = "./modules/apiv2"
#  http_method           = "GET"
#  lambda_name           = "${module.lambda.name}"
#  lambda_arn            = "${module.lambda.arn}"
#  aws_default_region    = "${var.aws_default_region}"
#  stage_name            = var.stage_name
#}
