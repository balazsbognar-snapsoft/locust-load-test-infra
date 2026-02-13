locals {
    root_module = "github-oidc-integration"
  }

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

inputs = {
  allowed_github_repositories = [
    "balazsbognar-snapsoft/test-oidc-login-to-aws"
  ]
}


include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
