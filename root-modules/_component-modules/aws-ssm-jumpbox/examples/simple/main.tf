data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

module "label" {
  source    = "../../../null-label"
  namespace = "example"
  name      = "ssm-jumpbox"
}

# Network

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = module.label.tags
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"

  tags = module.label.tags
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

  vpc_id                  = aws_vpc.this.id
  subnet_id               = aws_subnet.this.id
  add_interface_endpoints = true
  add_gateway_endpoints   = true

  instance_keeper = "2022-07-22"

  add_trusted_ca_cert = file("test-certificate.pem")
}
