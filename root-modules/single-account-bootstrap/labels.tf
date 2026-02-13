module "label_global_context" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = "global"
  tags        = var.common_tags
}

module "label_management_context" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = "management"
  tags        = var.common_tags
}

#############################
#        State Bucket       #
#############################
module "label_state_bucket_s3_bucket" {
  source             = "../_component-modules/null-label"
  context            = module.label_global_context.context
  name               = "terraform-state"
  resource_type      = local.resource_type.aws_s3_bucket
  additional_tag_map = { protection-level = local.protection-level.protected }
}

module "label_state_bucket_kms" {
  source             = "../_component-modules/null-label"
  context            = module.label_global_context.context
  name               = "terraform"
  resource_type      = local.resource_type.aws_kms_key
  additional_tag_map = { protection-level = local.protection-level.protected }
}
#############################
#       State managers      #
#############################

module "label_global_state_manager" {
  source        = "../_component-modules/null-label"
  context       = module.label_global_context.context
  name          = "state-manager"
  resource_type = local.resource_type.aws_iam_role
}

module "label_global_ro_state_manager" {
  source        = "../_component-modules/null-label"
  context       = module.label_global_context.context
  name          = "state-manager-ro"
  resource_type = local.resource_type.aws_iam_role
}

module "label_management_state_manager" {
  source        = "../_component-modules/null-label"
  context       = module.label_management_context.context
  name          = "state-manager"
  resource_type = local.resource_type.aws_iam_role
}

module "label_management_ro_state_manager" {
  source        = "../_component-modules/null-label"
  context       = module.label_management_context.context
  name          = "state-manager-ro"
  resource_type = local.resource_type.aws_iam_role
}

module "label_management_workload_access_role" {
  source        = "../_component-modules/null-label"
  context       = module.label_management_context.context
  name          = "workload-access"
  resource_type = local.resource_type.aws_iam_role
}


#############################
#        Deployer roles     #
#############################

module "label_global_deployer_role" {
  source        = "../_component-modules/null-label"
  context       = module.label_global_context.context
  name          = "terraform-deployer"
  resource_type = local.resource_type.aws_iam_role
}

module "label_global_deployer_role_policy" {
  source        = "../_component-modules/null-label"
  context       = module.label_global_context.context
  name          = "deployer-role"
  resource_type = local.resource_type.aws_iam_policy
}

module "label_global_deployer_state_bucket_policy" {
  source        = "../_component-modules/null-label"
  context       = module.label_global_context.context
  name          = "state-bucket-kms"
  resource_type = local.resource_type.aws_iam_policy
}

module "label_management_deployer_role" {
  source        = "../_component-modules/null-label"
  context       = module.label_management_context.context
  name          = "terraform-deployer"
  resource_type = local.resource_type.aws_iam_role
}
