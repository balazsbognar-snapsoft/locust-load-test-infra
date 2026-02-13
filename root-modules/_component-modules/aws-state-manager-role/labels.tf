module "label_context" {
  source  = "../null-label"
  context = var.context
}

module "label_iam_role" {
  source        = "../null-label"
  context       = var.context
  resource_type = "iam-role"
}

module "label_iam_policy" {
  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name}-bucket-access"
  resource_type = "iam-policy"
}

module "label_ro_iam_role" {
  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name}-ro"
  resource_type = "iam-role"
}

module "label_ro_iam_policy" {
  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name}-bucket-ro-access"
  resource_type = "iam-policy"
}