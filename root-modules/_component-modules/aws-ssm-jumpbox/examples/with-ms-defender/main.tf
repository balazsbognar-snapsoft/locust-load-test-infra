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

resource "aws_vpc_endpoint" "this" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = module.label.tags
}

resource "aws_vpc_endpoint_route_table_association" "this" {
  route_table_id  = aws_vpc.this.default_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.this.id
}

# Optionally internet GW and public route
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = module.label.tags
}

resource "aws_route" "internet" {
  route_table_id         = aws_vpc.this.default_route_table_id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

#################################
# Module
#################################

module "jumpbox" {
  source = "../../"

  context         = module.label.context
  region          = data.aws_region.this.name
  organization_id = data.aws_organizations_organization.this.id
  account_id      = data.aws_caller_identity.this.account_id

  vpc_id                      = aws_vpc.this.id
  subnet_id                   = aws_subnet.this.id
  add_interface_endpoints     = true
  add_gateway_endpoints       = false
  associate_public_ip_address = true

  instance_keeper = "2023-07-25-4"

  role_permission_configuration = {
    s3 = {
      read = ["${module.bucket.content_bucket.bucket}/*"]
    }
  }

  ms_defender = {
    dependencies = {
      s3_bucket_name          = module.bucket.content_bucket.bucket
      s3_folder_path          = "ms-defender"
      mde_netfilter_file_name = "mde-netfilter_100.69.59.x86_64.rpm"
      mdatp_file_name         = "mdatp_101.98.89.x86_64.rpm"
      mdatp_onboard_file_name = "mdatp_onboard.json"
    }
  }
  hostname = "asd"
}

#################################
# MS Defender resources
#################################

module "bucket" {
  source        = "../../../aws-s3-bucket"
  context       = module.label.context
  region        = data.aws_region.this.name
  account_id    = data.aws_caller_identity.this.account_id
  sse_algorithm = "AES256"
  force_destroy = true
}

# Objects should be uploaded:
#   - ms-defender/mde-netfilter_100.69.59.x86_64.rpm (https://packages.microsoft.com/rhel/7.2/prod/Packages/m/mde-netfilter_100.69.59.x86_64.rpm)
#   - ms-defender/mdatp_101.98.89.x86_64.rpm (https://packages.microsoft.com/rhel/7.2/prod/Packages/m/mdatp_101.98.89.x86_64.rpm)
#   - ms-defender/mdatp_onboard.json (downloadable from Azure)
