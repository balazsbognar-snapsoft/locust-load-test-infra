locals {
  root_module                    = "single-account-bootstrap"
  region                         = "eu-central-1"
  management_account_id          = get_aws_account_id()
  namespace                      = "snapsoft-locust"
  initial_deployer_iam_user_name = "terraform-deployer-user"
}

terraform {
  source = "../../../root-modules//${local.root_module}"
}

inputs = {
  management_account_id           = local.management_account_id
  state_bucket_account_id         = local.management_account_id
  region                          = local.region
  initial_deployer_iam_user_name  = local.initial_deployer_iam_user_name
  namespace                       = local.namespace
  management_workload_account_ids = [local.management_account_id]
  force_destroy                   = false # Set to true if you want to destroy the state bucket and all its contents
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
    allowed_account_ids = ["${local.management_account_id}"]
    default_tags {
      tags = {
        Source     = "/global/single-account-bootstrap"
        Phase      = "Bootstrap"
      }
    }
  }
  EOF
}

# remote_state {
#   backend = "local"
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite"
#   }
#   config = {
#     path = "${get_terragrunt_dir()}/terraform.tfstate"
#   }
# }


include "root" {
  path = find_in_parent_folders("global.hcl")
}
