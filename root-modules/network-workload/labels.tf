module "label_context" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = var.environment
}

module "vpc_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "main-vpc"

}

module "igw_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "igw"

}

module "nat_gw_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "nat-gw"

}

module "nat_gw_eip_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "nat-gw-eip"

}

module "public_subnet_label" {
  source = "../_component-modules/null-label"

  for_each = local.availability_zones

  context = module.label_context.context
  name    = "public-subnet-${each.key}"

}

module "public_rt_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "public-rt"

}

module "ecs_subnet_label" {
  source = "../_component-modules/null-label"

  for_each = local.availability_zones

  context = module.label_context.context
  name    = "ecs-subnet-${each.key}"

}


module "ecs_private_rt_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "ecs-private-rt"

}

module "db_subnet_label" {
  source = "../_component-modules/null-label"

  for_each = local.availability_zones

  context = module.label_context.context
  name    = "db-subnet-${each.key}"

}

module "db_rt_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "database-rt"

}

module "redshift_subnet_label" {
  source = "../_component-modules/null-label"

  for_each = local.availability_zones

  context = module.label_context.context
  name    = "redshift-subnet-${each.key}"

}

module "redshift_rt_label" {
  source = "../_component-modules/null-label"

  context = module.label_context.context
  name    = "redshift-rt"

}

module "rds_sg_label" {
  source = "../_component-modules/null-label"

  context       = module.label_context.context
  name          = "psql-rds"
  resource_type = "security-group"

}

module "ecs_sg_label" {
  source = "../_component-modules/null-label"

  context       = module.label_context.context
  name          = "ecs"
  resource_type = "security-group"
}

module "label_vpc_endpoints_sg" {
  source = "../_component-modules/null-label"

  context       = module.label_context.context
  name          = "vpc-endpoints"
  resource_type = "security-group"
}

module "ecr_vpc_endpoint_label" {
  source = "../_component-modules/null-label"

  context       = module.label_context.context
  name          = "ecr-dkr"
  resource_type = "vpc-interface-endpoint"

}

module "s3_gw_endpoint_label" {
  source = "../_component-modules/null-label"

  context       = module.label_context.context
  name          = "s3"
  resource_type = "vpc-gateway-endpoint"

}
