data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

module "label" {
  source    = "../../null-label"
  namespace = "example"
  name      = "ssm-endpoints"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"

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

module "ssm_endpoints" {
  source = "../"

  region                  = data.aws_region.this.name
  organization_id         = data.aws_organizations_organization.this.id
  account_id              = data.aws_caller_identity.this.account_id
  context                 = module.label.context
  vpc_id                  = aws_vpc.this.id
  subnet_id               = aws_subnet.this.id
  add_gateway_endpoints   = false
  add_interface_endpoints = false
}
