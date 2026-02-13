terraform {
  required_version = ">= v1.10.6"
}

resource "random_string" "random" {
  length  = 16
  special = false

}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "eu-central-1"
}

module "context" {
  source      = "../../null-label"
  namespace   = "lemontaps"
  environment = "global"
}

module "deployer_role_name_label" {
  source        = "../../null-label"
  context       = module.context.context
  resource_type = "iam-role"
  name          = "terraform-prod-deployer"
}

module "role_to_be_assumed_by_deployer_label" {
  source        = "../../null-label"
  context       = module.context.context
  name          = "OrganizationAccountAccessRole"
  resource_type = "iam-role"
}

resource "aws_iam_role" "role_to_be_assumed_by_deployer" {
  name               = module.role_to_be_assumed_by_deployer_label.id
  assume_role_policy = data.aws_iam_policy_document.this.json

  tags = module.role_to_be_assumed_by_deployer_label.tags
}
data "aws_iam_policy_document" "this" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${module.terraform_prod_deployer_role.role.name}"
      ]
      type = "AWS"
    }

  }
}
resource "aws_iam_user" "trusted_entity_of_deployer" {
  name = "technical_user"
}
module "terraform_prod_deployer_role" {
  source  = "../"
  context = module.deployer_role_name_label.context
  assumable_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/${module.role_to_be_assumed_by_deployer_label.id}"
  ]
  principals = {
    AWS = [
      "arn:aws:iam::${data.aws_caller_identity.current.id}:user/${aws_iam_user.trusted_entity_of_deployer.name}"
    ]
  }
}

output "deployer" {
  value = aws_iam_role.role_to_be_assumed_by_deployer
}

output "role" {
  value = module.terraform_prod_deployer_role.role
}
