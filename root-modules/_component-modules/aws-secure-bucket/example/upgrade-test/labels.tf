module "label_msk_bucket" {
  source        = "../../../null-label"
  context       = module.label_global_context.context
  name          = "msk-logs"
  resource_type = local.resource_type.aws_s3_bucket
}


module "label_state_bucket_s3_bucket" {
  source             = "../../../null-label"
  context            = module.label_global_context.context
  name               = "terraform-state"
  resource_type      = local.resource_type.aws_s3_bucket
  additional_tag_map = { protection-level = local.protection-level.protected }

}

module "label_platform_state_bucket_s3_bucket" {
  source             = "../../../null-label"
  context            = module.label_global_context.context
  name               = "platform-state"
  resource_type      = local.resource_type.aws_s3_bucket
  additional_tag_map = { protection-level = local.protection-level.protected }

}

module "label_internal_state_bucket_s3_bucket" {
  source             = "../../../null-label"
  context            = module.label_global_context.context
  name               = "internal-state"
  resource_type      = local.resource_type.aws_s3_bucket
  additional_tag_map = { protection-level = local.protection-level.protected }

}

module "label_global_context" {
  source      = "../../../null-label"
  namespace   = "snapsoft"
  environment = "sbxg"
  tags        = var.common_tags

}
module "label_config_log_bucket" {
  source        = "../../../null-label"
  context       = module.label_global_context.context
  name          = "config-logs"
  resource_type = local.resource_type.aws_s3_bucket
}
module "label_organization_trail_s3_bucket" {
  source  = "../../../null-label"
  context = module.label_global_context.context
  name    = "organization-trail"
}
module "label_ssm_logs_s3_bucket" {
  source  = "../../../null-label"
  context = module.label_global_context.context
  name    = "ssm-baseline"
}
