output "bucket" {
  description = "Name of the logging bucket"
  value       = module.s3_logging.bucket
}