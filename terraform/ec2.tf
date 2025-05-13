# Launch key
resource "aws_key_pair" "launch" {
  key_name   = local.deployment_prefix
  public_key = file(var.public_key_path)
}