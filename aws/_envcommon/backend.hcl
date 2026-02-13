locals {
  namespace                     = "snapsoft-locust"
  s3_backend_account_id         = "563149050409"
  s3_backend_bucket_region      = "eu-central-1"
  s3_backend_bucket_name        = "${local.namespace}-global-terraform-state-s3-bucket"
  s3_backend_kms_key_arn        = "arn:aws:kms:${local.s3_backend_bucket_region}:${local.s3_backend_account_id}:alias/state-bucket-kms"
  s3_backend_state_manager_role = "${local.namespace}-global-state-manager-iam-role"
}
