module "label_context" {
  source      = "../null-label"
  namespace   = var.namespace
  environment = var.environment
}

module "label_vpc_peering" {
  source        = "../null-label"
  context       = module.label_context.context
  name          = var.vpc_peering_connection_name
  enabled       = var.enable_vpc_peering
  resource_type = "vpc-peering"
}

module "label_vpc_peering_accepter" {
  source        = "../null-label"
  context       = module.label_context.context
  name          = var.vpc_peering_connection_name
  enabled       = var.enable_vpc_peering
  resource_type = "vpc-peering-accepter"
}
