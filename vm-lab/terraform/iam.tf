# Systems Manager SSM
resource "aws_iam_role" "ssm" {
  name = join("-", [var.name, "ssm"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ssm"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.standard_tags
}

# SSM connections
resource "aws_iam_role_policy_attachment" "ssm" {
  for_each = toset([
    data.aws_iam_policy.AmazonCloudWatchAgentServerPolicy.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCorePolicy.arn
  ])

  role       = aws_iam_role.ssm.name
  policy_arn = each.value
}

# Ansible SSM
resource "aws_iam_policy" "ansible" {
  name        = "${var.name}-ansible-ssm"
  description = "Allows Ansible to connect over SSM"

  policy = templatefile("templates/iam-s3-ansible-ssm-policy.json.tmpl", {
    bucket = aws_s3_bucket.ssm.bucket
  })

  tags = local.standard_tags
}

resource "aws_iam_role_policy_attachment" "ansible" {
  policy_arn = aws_iam_policy.ansible.arn
  role       = aws_iam_role.ssm.name
}

resource "aws_iam_instance_profile" "ssm" {
  name = join("-", [var.name, "-ssm"])
  role = aws_iam_role.ssm.name

  tags = local.standard_tags
}