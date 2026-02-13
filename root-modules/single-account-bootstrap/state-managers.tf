module "global_state_manager_role" {
  source    = "../_component-modules/aws-state-manager-role"
  # providers = { aws = aws.deployments } # Only enable if you want to place the tfstate bucket into a separate account

  paths                 = ["global/*"]
  s3_backend_bucket_arn = module.terraform_state_secure_bucket.content_bucket.arn
  context               = module.label_global_state_manager.context
  principals = {
    AWS = [
      "arn:aws:iam::${var.management_account_id}:role/${aws_iam_role.terraform_global_deployer_role.name}"
    ]
  }
  kms_key_arn = aws_kms_key.terraform_kms.arn
}

module "management_state_manager_role" {
  source    = "../_component-modules/aws-state-manager-role"


  kms_key_arn           = aws_kms_key.terraform_kms.arn
  paths                 = ["management/*"]
  s3_backend_bucket_arn = module.terraform_state_secure_bucket.content_bucket.arn
  context               = module.label_management_state_manager.context
  principals = {
    AWS = [
      "arn:aws:iam::${var.management_account_id}:role/${module.terraform_management_deployer_role.role.name}"
    ]
  }
}
