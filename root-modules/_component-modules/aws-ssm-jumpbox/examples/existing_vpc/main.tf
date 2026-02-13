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
  id = "vpc-0c95f81657c382848"
}

data "aws_subnet" "this" {
  id = "subnet-0ce7fbd2f44c62a01"
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
  add_interface_endpoints = true
  add_gateway_endpoints   = true

  instance_keeper = "2022-07-22"

}