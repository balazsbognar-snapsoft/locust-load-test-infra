module "label" {
  source  = "../null-label"
  context = var.context
  name    = "${var.context.name}-ies"
}

module "label_sg" {
  count = var.add_interface_endpoints ? 1 : 0

  source        = "../null-label"
  context       = module.label.context
  resource_type = "ec2-sg"
}

module "label_interface_endpoint" {
  for_each = local.interface_endpoint_services

  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name}-${replace(each.key, "_", "-")}"
  resource_type = "interface-endpoint"
}

module "label_gateway_endpoint" {
  for_each = local.gateway_endpoint_services

  source        = "../null-label"
  context       = module.label.context
  name          = "${var.context.name}-${replace(each.key, "_", "-")}"
  resource_type = "gateway-endpoint"
}