locals {
  root_module = "ecr-repository"
}

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

dependencies {
  paths = ["../master-host", "../../eu-west-1/worker-host-1"]
}

inputs = {
  account_id = include.root.locals.account_id
  account_ids = [
    include.root.locals.account_id # Gives only read access
  ]
  repositories = [
    "locust-artifacts",
    "locust-init-downloader",
    "locust-perftester"
  ]

  trusted_principle_arns = [
    "arn:aws:iam::${include.root.locals.account_id}:user/terraform-deployer-user",
    "arn:aws:iam::${include.root.locals.account_id}:role/snapsoft-locust-dev-locust-master-iam-role",
    "arn:aws:iam::${include.root.locals.account_id}:role/snapsoft-locust-dev-locust-worker-1-iam-role",
    "arn:aws:iam::${include.root.locals.account_id}:role/snapsoft-locust-dev-github-actions-iam-role"
  ]

  kms_key_name = "ecr-key"
}

include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
