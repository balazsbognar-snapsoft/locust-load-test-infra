module "label_endpoints" {
  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name == null ? "" : var.context.name}-ep"
  resource_type = local.resource_types.iam_role
}

module "label_role" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.iam_role
}

module "label_policy" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.iam_policy
}

module "label_custom_policy" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.iam_policy
}

module "label_instance_profile" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.ec2_instance_profile
}

module "label_sg" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.ec2_sg
}

module "label_ec2_instance" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.ec2_instance
}

module "label_mac_host" {
  source        = "../null-label"
  context       = var.context
  name          = "mac-m2"
  resource_type = local.resource_types.dedicated_host
}

module "label_ebs" {
  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.ebs
}

module "label_ssm_attach_efs" {
  count = var.efs_mounts == {} ? 0 : 1

  source        = "../null-label"
  context       = var.context
  resource_type = local.resource_types.ssm_document
}

module "label_generated_policy" {
  count         = var.role_permission_configuration == null ? 0 : 1
  source        = "../null-label"
  name          = "${var.context.name == null ? "" : var.context.name}-generated"
  context       = var.context
  resource_type = local.resource_types.iam_policy
}
