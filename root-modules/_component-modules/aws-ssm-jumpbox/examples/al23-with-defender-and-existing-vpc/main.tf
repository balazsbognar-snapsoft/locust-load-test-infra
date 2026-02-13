data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

module "label" {
  source    = "../../../null-label"
  namespace = "example-AL23"
  name      = "ssm-jumpbox"
}

# Network

data "aws_vpc" "this" {
  id = "vpc-0fcf2826462e9e138"
}

data "aws_subnet" "this" {
  id = "subnet-0ddb1b1dd5fe916b0"
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
  ami_id                  = "amazon-linux-2023"
  instance_keeper         = "2022-07-23"
  ms_defender = {
    dependencies = {

      s3_bucket_name          = "sandbox-jumpbox-resources-bucket"
      s3_folder_path          = "ms-defender"
      mde_netfilter_file_name = "mde-netfilter-100.69.73-1.x86_64.rpm"
      mdatp_file_name         = "mdatp-101.25012.0000-1.x86_64.rpm"
      mdatp_onboard_file_name = "mdatp_onboard_2023_07_25.json"
    }
  }

}

output "module" {
  value = module.jumpbox
}