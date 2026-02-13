
output "content_bucket" {
  description = "This S3 bucket."
  value       = aws_s3_bucket.content
}

output "log_bucket" {
  description = "The S3 bucket used for storing access logs of this bucket."
  value       = aws_s3_bucket.access_log
}

#output "template" {
#  value = {
#    bucket_name = aws_s3_bucket.content.id
#    access_bucket_anem = aws_s3_bucket.access_log.id
#    kms_key = var.kms_master_key_id
#    sse_algorith = var.sse_algorithm
#    object_lock_enabled = var.object_lock_configuration.enabled
#    lifecycle_configuration_enabled = var.lifecycle_configuration
#  }
#}