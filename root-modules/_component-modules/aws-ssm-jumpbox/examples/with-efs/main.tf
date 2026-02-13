data "aws_organizations_organization" "this" {}
data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

module "label" {
  source    = "../../../null-label"
  namespace = "example"
  name      = "ssm-jumpbox"
}

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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route" "internet_rt" {
  route_table_id         = aws_vpc.this.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_efs_file_system" "this" {
  encrypted = true

  tags = module.label.tags
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
  posix_user {
    gid = 1000
    uid = 1000
  }
  root_directory {
    path = "/efs-example"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "700"
    }
  }
}

#################################
#            Module             #
#################################

module "jumpbox" {
  source = "../../"

  context         = module.label.context
  region          = data.aws_region.this.name
  account_id      = data.aws_caller_identity.this.account_id
  organization_id = data.aws_organizations_organization.this.id

  vpc_id                      = aws_vpc.this.id
  subnet_id                   = aws_subnet.this.id
  associate_public_ip_address = true
  add_interface_endpoints     = true
  add_gateway_endpoints       = true
  efs_mounts = {
    this = {
      file_system_id  = aws_efs_file_system.this.id
      access_point_id = aws_efs_access_point.this.id
      mount_path      = "/mnt/efs01"
    }
  }
}
