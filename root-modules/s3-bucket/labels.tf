module "label_context" {
  source      = "../_component-modules/null-label"
  namespace   = startswith(var.name_prefix, "aws-waf-logs") ? "aws-waf-logs-${var.namespace}" : var.namespace
  environment = var.environment
  tags        = var.common_tags
}

module "label_bucket_s3_bucket" {
  source        = "../_component-modules/null-label"
  context       = module.label_context.context
  name          = var.name
  resource_type = "s3-bucket"
}
