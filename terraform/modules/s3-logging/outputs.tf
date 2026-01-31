output "bucket" {
  description = "Name of the logging bucket"
  value       = aws_s3_bucket.this.bucket
}