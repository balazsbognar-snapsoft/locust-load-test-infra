data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  n = 10
}

module "label" {
  count     = local.n
  source    = "../../../null-label"
  namespace = "example"
  name      = "szabi-ssm-jumpbox-${count.index}"
}

# Network

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = module.label[0].tags
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = module.label[0].tags
}

#################################
#            Module             #
#################################

module "jumpbox" {
  source = "../../"

  count = local.n

  context         = module.label[count.index].context
  region          = data.aws_region.this.name
  organization_id = data.aws_organizations_organization.this.id
  account_id      = data.aws_caller_identity.this.account_id

  vpc_id                  = "vpc-0b80b7471993e96ad"
  subnet_id               = "subnet-0677080f1b3e1918e"
  add_interface_endpoints = false
  add_gateway_endpoints   = false

  network_tester_instance_enabled = true

  available_interface_endpoints = ["ssm.eu-central-1.amazonaws.com"]

  instance_keeper = "2022-07-22"

}
