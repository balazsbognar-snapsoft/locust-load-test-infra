module "this" {
  source                                 = "../_component-modules/aws-secure-bucket"
  context                                = module.label_bucket_s3_bucket.context
  sse_algorithm                          = var.sse_algorithm
  kms_master_key_id                      = var.create_kms_key_for_s3_encryption ? module.kms_key_for_s3[0].key_arn : null
  use_acl_for_access_logs                = var.use_acl_for_access_logs
  content_bucket_public_access_block     = var.content_bucket_public_access_block
  content_bucket_object_ownership        = var.content_bucket_object_ownership
  bucket_key_enabled                     = var.bucket_key_enabled
  blocked_encryption_types               = var.blocked_encryption_types
  use_acl_for_content                    = var.use_acl_for_content
  s3_content_bucket_acp_grants           = var.s3_content_bucket_acp_grants
  cors_rules                             = var.s3_content_bucket_cors_rules
  lifecycle_configuration                = var.lifecycle_configuration
  lifecycle_configuration_for_content    = var.lifecycle_configuration_for_content
  transition_default_minimum_object_size = var.transition_default_minimum_object_size
  custom_iam_statements                  = var.custom_iam_statements
}
