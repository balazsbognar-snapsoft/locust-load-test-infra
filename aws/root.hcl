terragrunt_version_constraint = "0.98.0"
terraform_version_constraint  = "1.11.3"

# Assume IAM role
# https://terragrunt.gruntwork.io/docs/features/authentication/#configuring-terragrunt-to-assume-an-iam-role
iam_role                 = "arn:aws:iam::${local.deployer_roles_account_id}:role/${local.deploy_iam_role}" # Initial role that be assumed by a user or a role
iam_assume_role_duration = 60 * 60

# To use OIDC authentication
# iam_web_identity_token = get_env("AN_OIDC_TOKEN")


locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  deployer_roles_account_id = get_aws_account_id() # can be used with single-account setup
  deploy_iam_role           = "${local.namespace}-management-terraform-deployer-iam-role"
  terraform_role_to_assume  = "${local.namespace}-management-workload-access-iam-role"

  s3_backend_config             = read_terragrunt_config("${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/backend.hcl")
  s3_backend_bucket_name        = local.s3_backend_config.locals.s3_backend_bucket_name
  s3_backend_bucket_region      = local.s3_backend_config.locals.s3_backend_bucket_region
  s3_backend_account_id         = local.s3_backend_config.locals.s3_backend_account_id
  s3_backend_kms_key_arn        = local.s3_backend_config.locals.s3_backend_kms_key_arn
  s3_backend_state_manager_role = "${local.namespace}-management-state-manager-iam-role"

  account_id = local.account_vars.locals.aws_account_id
  region     = local.region_vars.locals.region
  namespace  = "snapsoft-locust"

  # org_access_role = "OrganizationAccountAccessRole"

}

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
    key                   = "management/${path_relative_to_include()}/tofu.tfstate"
    encrypt               = true
    kms_key_id            = "${local.s3_backend_kms_key_arn}"
    use_lockfile          = true
    assume_role = {
      role_arn = "arn:aws:iam::${local.s3_backend_account_id}:role/${local.s3_backend_state_manager_role}"
    }
  }
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"

    # Only these AWS Account IDs may be operated on by this template
    allowed_account_ids = ["${local.account_id}"]

    assume_role {
      role_arn= "arn:aws:iam::${local.account_id}:role/${local.terraform_role_to_assume}" # This role will be assumed by the deployer role
    }

    default_tags {
      tags = {
        Source     = "${length(path_relative_to_include()) > 256 ? format("...%s", substr(path_relative_to_include(), -252, -1)) : path_relative_to_include()}"
      }
    }
  }
  EOF
}

inputs = {
  environment = local.environment_vars.locals.environment
  region      = local.region_vars.locals.region
  namespace   = local.namespace
}
