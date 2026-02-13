terraform {
  required_version = ">= v1.10.6"
}
provider "aws" {
  region = "eu-central-1"
}

module "label_compliance_bucket" {
  source        = "../../../null-label"
  environment   = "iac-test"
  namespace     = "snapsoft"
  resource_type = "s3-bucket"
  name          = "compliance-test"
}

module "compliance_bucket" {
  source        = "../../"
  context       = module.label_compliance_bucket.context
  sse_algorithm = "AES256"
  object_lock_configuration = {
    enabled = true,
    mode    = "COMPLIANCE",
    days    = 1,
    years   = null
  }
}