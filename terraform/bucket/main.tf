data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "default" {
  bucket = var.bucket
  acl    = var.acl
  force_destroy = var.force_destroy

  tags = merge(
    var.cloud_tags,
    {
      Product = "s3"
    },
  )

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {

    enabled = var.enable_lifecycle

    expiration {
      days = var.expire_days
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#  dynamic "default_action" {
#    for_each = var.maintenance_mode ? [] : [1]
#    content {
#      type             = "forward"
#      target_group_arn = aws_lb_target_group.this.arn
#    }
#  }
#
#  dynamic "default_action" {
#    for_each = var.maintenance_mode ? [1] : []
#    content {
#      type = "fixed-response"
#      fixed_response {
#        content_type = "text/html"
#        message_body = file("${path.module}/pages/scheduled-maintenance.html")
#        status_code  = "503"
#      }
#    }
#  }

