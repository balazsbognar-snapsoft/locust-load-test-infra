
module "kms_key_for_s3" {
  source = "../_component-modules/aws-kms-key-internal"

  count = var.create_kms_key_for_s3_encryption ? 1 : 0

  context = module.label_context.context
  region  = var.region


  key_name               = var.kms.key_name
  account_id             = var.account_id
  enable_log_permissions = false
  trusted_principle_arns = var.kms.trusted_principle_arns
}
