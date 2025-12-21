# Systems Manager SSM
resource "aws_iam_role" "ssm" {
  name = join("-", [local.resource_prefix, "ssm"])
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

resource "aws_iam_instance_profile" "ssm" {
  name = join("-", [local.resource_prefix, "-ssm"])
  role = aws_iam_role.ssm.name

  tags = local.standard_tags
}