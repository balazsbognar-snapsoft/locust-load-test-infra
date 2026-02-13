terraform {
  required_version = ">= v1.10.6"
}

provider "aws" {
  region = "eu-central-1"
}

module "label" {
  source    = "../../null-label"
  namespace = "example"
  name      = "ecr_repository_internal"
}

module "ecr_repository_internal" {
  source  = "../"
  context = module.label.context

  repository_name = "sandbox-test-repo-internal"
  #mkb-sandbox-integration-1
  account_ids = ["102341093596"]
  trusted_principle_arns = [
    "arn:aws:iam::403027025526:user/ecr-technical-user-poc",
    "arn:aws:iam::403027025526:user/ecr-central-role-poc"
  ]
}