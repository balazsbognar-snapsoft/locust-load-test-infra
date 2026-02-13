module "label_context" {
  source      = "../null-label"
  namespace   = var.namespace
  environment = var.environment
}

module "label_vpc_origin" {
  source        = "../null-label"
  context       = module.label_context.context
  name          = var.name
  resource_type = "vpc-origin"
}