module "label_context" {
  source      = "../_component-modules/null-label"
  namespace   = var.namespace
  environment = var.environment
}

module "label_github_oidc_provider" {
  source        = "../_component-modules/null-label"
  context       = module.label_context.context
  name          = "github"
  resource_type = "oidc-provider"
}

module "label_github_actions_role" {
  source        = "../_component-modules/null-label"
  context       = module.label_context.context
  name          = "github-actions"
  resource_type = "iam-role"
}
