#------------------------------------------------------------------------------
# Logging

#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "logging" {
  bucket = "${local.account_id}-${var.name}-logging"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryptor.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logging" {
  bucket                  = aws_s3_bucket.logging.bucket
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "logging" {
  statement {
    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logging.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  policy = data.aws_iam_policy_document.logging.json
}

resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  bucket = aws_s3_bucket.logging.bucket
  rule {
    id     = "rule-01"
    status = "Enabled"

    expiration {
      days = 7
    }

    filter {}
  }
}
