module "global_context" {
  source      = "../../"
  namespace   = "sre"
  environment = "global"
}
module "iam_role_name" {
  source        = "../../"
  context       = module.global_context.context
  name          = "terraform-state-manager"
  resource_type = "iam-role"
}
terraform {
  required_version = ">= v1.10.6"
}

output "global_context" {
  value = {
    id            = module.global_context.id
    name          = module.global_context.name
    namespace     = module.global_context.namespace
    stage         = module.global_context.stage
    resource_type = module.global_context.resource_type
    attributes    = module.global_context.attributes
    delimiter     = module.global_context.delimiter
  }
}


output "global_context_normalized_context" {
  value = module.global_context.normalized_context
}
output "label2_normalized_context" {
  value = module.iam_role_name.normalized_context
}