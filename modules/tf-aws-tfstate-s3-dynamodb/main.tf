locals {
  region = var.append_region_to_name ? var.bucket_region : ""
  name   = var.bucket_name != "" ? var.bucket_name : "${var.bucket_name_prefix}-${join("-", distinct(compact([var.project_name, var.environment, local.region])), )}-${var.bucket_name_suffix}"
}

resource "aws_s3_bucket" "default" {
  bucket        = local.name
  acl           = var.bucket_acl
  #region        = var.bucket_region
  force_destroy = var.bucket_force_destroy

  versioning {
    enabled    = var.bucket_versioning
    mfa_delete = var.bucket_mfa_delete
  }

  logging {
    target_bucket = var.access_logs_bucket_name
    target_prefix = "access-logs/${local.name}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # lifecycle_rule {
  #   enabled                                = true
  #   prefix                                 = ""
  #   abort_incomplete_multipart_upload_days = 14
  #
  #   transition {
  #     days          = 4
  #     storage_class = "INTELLIGENT_TIERING"
  #   }
  #
  #   transition {
  #     days          = 34
  #     storage_class = "GLACIER"
  #   }
  #
  #   expiration {
  #     days = 399
  #   }
  # }
  #
  # lifecycle_rule {
  #   enabled = true
  #   prefix  = ""
  #   id      = "ExpireDeleteMarkers"
  #
  #   expiration {
  #     expired_object_delete_marker = true
  #   }
  # }
  #
  # lifecycle {
  #   prevent_destroy = false
  # }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true

  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true

  # Block new public bucket policies
  block_public_policy = true

  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "default" {
  name           = "${local.name}-lock"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = var.dynamodb_server_side_encryption_enabled
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = var.tags
}
