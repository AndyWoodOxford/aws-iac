# modules/s3





<!-- BEGIN_TF_DOCS -->
## Table of Contents

- [Requirements][1]
- [Inputs][2]
- [Outputs][3]
- [Modules][4]
- [Resources][5]



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Create the bucket if, and only if, this is true | `bool` | `true` | no |
| <a name="input_expiry_in_days"></a> [expiry\_in\_days](#input\_expiry\_in\_days) | Objects expire after this many days | `number` | `7` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the bucket. If omitted, Terraform will assign a random name. | `string` | `null` | no |
| <a name="input_sse_key_arn"></a> [sse\_key\_arn](#input\_sse\_key\_arn) | ARN for the (optional) KMS SSE encryption key | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Add these tags to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Name of the logging bucket |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

[1]: #requirements
[2]: #inputs
[3]: #outputs
[4]: #modules
[5]: #resources
<!-- END_TF_DOCS -->
