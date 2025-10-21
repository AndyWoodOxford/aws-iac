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
        Sid    = "default",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
        },
        Action   = "kms:*",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
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
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.encryptor.key_id
}
