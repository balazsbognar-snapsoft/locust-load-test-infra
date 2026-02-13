data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

module "label" {
  source    = "../../../null-label"
  namespace = "example"
  name      = "ssm-jumpbox"
}

# Network

data "aws_vpc" "this" {
  id = "vpc-0c5bf48eca8e38aee"
}

data "aws_subnet" "this" {
  id = "subnet-06315f99aa66a59f9"
}

#################################
#            Module             #
#################################

module "jumpbox" {
  source = "../../"

  context         = module.label.context
  region          = data.aws_region.this.name
  organization_id = data.aws_organizations_organization.this.id
  account_id      = data.aws_caller_identity.this.account_id

  vpc_id                  = data.aws_vpc.this.id
  subnet_id               = data.aws_subnet.this.id
  add_interface_endpoints = false
  add_gateway_endpoints   = false

  ami_id          = "macos"
  instance_keeper = "2022-07-22"

  bitrise_token_secret_arn = "arn:aws:secretsmanager:eu-central-1:403027025526:secret:sbx-sre-macos-secret-cbmZCk"
  is_bitrise_runner        = true

  associate_public_ip_address = true
}
