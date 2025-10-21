# Launch key
resource "aws_key_pair" "launch" {
  key_name   = local.ec2_key_pair_name
  public_key = file(var.public_key_path)
}

# Instance
resource "aws_instance" "vm" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = local.ec2_key_pair_name

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 25
    encrypted             = true
    delete_on_termination = true
  }

  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  vpc_security_group_ids = [aws_security_group.vmlab.id]

  iam_instance_profile = aws_iam_instance_profile.ssm.name

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    local.standard_tags,
    {
      Name = (var.instance_count > 1
        ? format("%s-%d", local.standard_tags["name"], count.index + 1)
        : local.standard_tags["name"]
      )
    }
  )

  volume_tags = merge(local.standard_tags,
    {
      Name = (var.instance_count > 1
        ? format("%s-%d", local.standard_tags["name"], count.index + 1)
        : local.standard_tags["name"]
      )
    }
  )
}