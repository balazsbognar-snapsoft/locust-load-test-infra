output "move_blocks" {
  value = templatefile("templatefile.tmpl", {
    buckets = {
      config = {
        access_bucket_name  = "snapsoft-sbxg-config-logs-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-config-logs-s3-bucket"
        kms_key             = "arn:aws:kms:eu-central-1:503565054880:key/e9d7dfa9-ce83-4da0-a267-34ca445f2761"
        object_lock_enabled = false
        sse_algorithm       = "aws:kms"
        module_base_path    = "module.config_log_s3_bucket"
      }
      organization_msk_logs_s3_bucket = {
        access_bucket_name  = "snapsoft-sbxg-msk-logs-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-msk-logs-s3-bucket"
        kms_key             = "arn:aws:kms:eu-central-1:503565054880:key/e9d7dfa9-ce83-4da0-a267-34ca445f2761"
        object_lock_enabled = false
        sse_algorithm       = "aws:kms"
        module_base_path    = "module.organization_msk_logs_s3_bucket"
      }
      platform_state_secure_bucket = {
        access_bucket_name  = "snapsoft-sbxg-platform-state-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-platform-state-s3-bucket"
        kms_key             = "arn:aws:kms:eu-central-1:503565054880:key/e9d7dfa9-ce83-4da0-a267-34ca445f2761"
        object_lock_enabled = false
        sse_algorithm       = "aws:kms"
        module_base_path    = "module.platform_state_secure_bucket"
      }
      ssm_logs_s3_bucket = {
        access_bucket_name  = "snapsoft-sbxg-ssm-baseline-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-ssm-baseline-s3-bucket"
        kms_key             = null
        object_lock_enabled = false
        sse_algorithm       = "AES256"
        module_base_path    = "module.ssm_logs_s3_bucket"
      }
      terraform_internal_state_secure_bucket = {
        access_bucket_name  = "snapsoft-sbxg-internal-state-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-internal-state-s3-bucket"
        kms_key             = "arn:aws:kms:eu-central-1:503565054880:key/e9d7dfa9-ce83-4da0-a267-34ca445f2761"
        object_lock_enabled = false
        sse_algorithm       = "aws:kms"
        module_base_path    = "module.terraform_internal_state_secure_bucket"
      }
      terraform_state_secure_bucket = {
        access_bucket_name  = "snapsoft-sbxg-terraform-state-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-terraform-state-s3-bucket"
        kms_key             = "arn:aws:kms:eu-central-1:503565054880:key/e9d7dfa9-ce83-4da0-a267-34ca445f2761"
        object_lock_enabled = false
        sse_algorithm       = "aws:kms"
        module_base_path    = "module.terraform_state_secure_bucket"
      }
      trail = {
        access_bucket_name  = "snapsoft-sbxg-organization-trail-access-log-s3-bucket"
        bucket_name         = "snapsoft-sbxg-organization-trail-s3-bucket"
        kms_key             = null
        object_lock_enabled = true
        sse_algorithm       = "AES256"
        module_base_path    = "module.organization_trail_s3_bucket"
      }
    }
  })
}



