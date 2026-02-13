################################################################################
# VPC Module
################################################################################
module "vpc" {
  source               = "../_component-modules/aws-network"
  create_vpc           = true
  region               = var.region
  name                 = module.vpc_label.id_full
  cidr                 = var.cidr_block
  azs                  = local.availability_zones
  enable_dns_hostnames = true
  enable_dns_support   = true
  vpc_tags             = module.vpc_label.tags

  # IGW
  create_igw = true
  igw_tags   = module.igw_label.tags

  # NAT gw configuration (1/AZ )
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  nat_gateway_tags       = module.nat_gw_label.tags
  nat_eip_tags           = module.nat_gw_eip_label.tags

  # Public Subnets
  public_subnets      = var.public_subnets_cidr_block
  public_subnet_names = [for subnet in module.public_subnet_label : subnet.id_full]

  # Public route table
  public_route_table_tags = module.public_rt_label.tags

  # Private subnets
  private_subnet_suffix    = ""
  private_subnets          = var.private_subnets_cidr_block
  private_subnet_names     = [for subnet in module.ecs_subnet_label : subnet.id_full]
  private_route_table_tags = module.ecs_private_rt_label.tags

  # Database subnets
  database_subnet_suffix             = ""
  create_database_subnet_route_table = true
  create_database_subnet_group       = true
  database_subnets                   = var.database_subnets_cidr_block
  database_subnet_names              = [for subnet in module.db_subnet_label : subnet.id_full]
  database_route_table_tags          = module.db_rt_label.tags

  # Redshift subnets
  redshift_subnet_suffix             = ""
  create_redshift_subnet_route_table = true
  create_redshift_subnet_group       = false
  redshift_subnets                   = var.redshift_subnets_cidr_block
  redshift_subnet_names              = [for subnet in module.redshift_subnet_label : subnet.id_full]
  redshift_route_table_tags          = module.redshift_rt_label.tags

  manage_default_network_acl = false
  manage_default_route_table = false

  enable_flow_log             = var.enable_flow_log
  flow_log_destination_type   = var.flow_log_destination_type
  flow_log_destination_arn    = var.flow_log_destination_arn
  flow_log_file_format        = var.flow_log_file_format
  flow_log_per_hour_partition = var.flow_log_per_hour_partition

}

resource "aws_security_group" "vpc_endpoints" {
  name        = module.label_vpc_endpoints_sg.id_full
  description = "Security group for VPC endpoint"
  vpc_id      = module.vpc.vpc_id

  tags = module.label_vpc_endpoints_sg.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_ingress_https_for_vpc_endpoints" {
  description       = "Allow HTTPS traffic (ingress) for VPC endpoints"
  security_group_id = aws_security_group.vpc_endpoints.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = var.cidr_block
}


################################################################################
# VPC Endpoints module
################################################################################
module "vpc_endpoints" {
  source = "../_component-modules/aws-network/modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  create_security_group = false
  endpoints = {
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      private_dns_enabled = true
      route_table_ids     = module.vpc.private_route_table_ids
      tags                = module.s3_gw_endpoint_label.tags
    }
  }
}
