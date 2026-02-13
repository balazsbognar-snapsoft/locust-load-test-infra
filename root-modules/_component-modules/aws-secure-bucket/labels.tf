module "label_this_bucket" {
  source        = "../null-label"
  context       = var.context
  resource_type = "s3-bucket"
  label_order = var.s3_bucket_name_append_resource_name ? ["namespace", "environment", "name", "resource_type"] : [
    "namespace", "environment", "name"
  ]
}


module "label_access_log_bucket" {
  source        = "../null-label"
  context       = var.context
  name          = "${var.context.name}-access-log"
  resource_type = "s3-bucket"
  label_order = var.s3_access_log_bucket_name_append_resource_name ? [
    "namespace", "environment", "name", "resource_type"
    ] : [
    "namespace", "environment", "name"
  ]
}