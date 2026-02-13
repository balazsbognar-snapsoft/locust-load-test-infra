module "label" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = var.environment
  name        = "common"
}