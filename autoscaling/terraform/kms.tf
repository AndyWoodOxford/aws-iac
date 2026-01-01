resource "aws_kms_key" "encryptor" {
  description             = "General encryption e.g. S3 data"
  key_usage               = "ENCRYPT_DECRYPT"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "encryptor" {
  key_id = aws_kms_key.encryptor.id
  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${local.account_id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Sid    = "Allow access for Key Administrators",
        Effect = "Allow",
        "Principal" : {
          "AWS" = "arn:aws:iam::${local.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
        },
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "encryption_key" {
  name          = "alias/${var.resource_prefix}"
  target_key_id = aws_kms_key.encryptor.key_id
}
