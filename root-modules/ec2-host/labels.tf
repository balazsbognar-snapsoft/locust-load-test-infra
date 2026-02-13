module "label_context" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = var.environment
  name        = var.instance_name
}

module "label_ec2_instance" {
  source        = "../_component-modules/null-label"
  context       = module.label_context.context
  name          = var.instance_name
  resource_type = "instace"
}

module "label_ec2_sec_group" {
  source        = "../_component-modules/null-label"
  context       = module.label_context.context
  name          = var.instance_name
  resource_type = "sec-group"
}
