
module "kms_key" {
  source = "../_component-modules/aws-kms-key-internal"

  region     = var.region
  account_id = var.account_id

  key_name               = var.kms_key_name
  trusted_principle_arns = var.trusted_principle_arns
  context                = module.label.context
  enable_ecr_permissions = true
}

module "ecr" {
  source   = "../_component-modules/aws-ecr-repository-internal"
  for_each = toset(var.repositories)

  context = module.label.context

  repository_name = each.key
  account_ids     = var.account_ids

  trusted_principle_arns = var.trusted_principle_arns
  kms_master_key_id      = module.kms_key.key_arn
}

