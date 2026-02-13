# Everything under this should be commented out on first manual run
locals {
  s3_backend_config             = read_terragrunt_config("${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/backend.hcl")
  s3_backend_bucket_name        = local.s3_backend_config.locals.s3_backend_bucket_name
  s3_backend_bucket_region      = local.s3_backend_config.locals.s3_backend_bucket_region
  s3_backend_account_id         = local.s3_backend_config.locals.s3_backend_account_id
  s3_backend_kms_key_arn        = local.s3_backend_config.locals.s3_backend_kms_key_arn
  s3_backend_state_manager_role = local.s3_backend_config.locals.s3_backend_state_manager_role
  deployer_roles_account_id     = get_aws_account_id()
  # management account where the deployer roles reside, could come from dependency

  global_deployer_role_name = "snapsoft-locust-global-terraform-deployer-iam-role"
}

iam_role = "arn:aws:iam::${local.deployer_roles_account_id}:role/${local.global_deployer_role_name}"

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    disable_bucket_update = true
    region                = "${local.s3_backend_bucket_region}"
    bucket                = "${local.s3_backend_bucket_name}"
    key                   = "global/${path_relative_to_include()}/tofu.tfstate"
    encrypt               = true
    kms_key_id            = "${local.s3_backend_kms_key_arn}"
    use_lockfile          = true
    assume_role = {
      role_arn = "arn:aws:iam::${local.s3_backend_account_id}:role/${local.s3_backend_state_manager_role}"
    }
  }
}
