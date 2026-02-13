terraform {
  required_version = ">= v1.10.6"
}
provider "aws" {
  region = "eu-central-1"
}
resource "random_string" "random" {
  length  = 16
  special = false

}
module "label_default_bucket" {
  source        = "../../../null-label"
  environment   = "iac-test"
  namespace     = "snapsoft"
  resource_type = "s3-bucket"
  name          = random_string.random.id

}

module "config_log_s3_bucket" {
  source        = "../../"
  context       = module.label_default_bucket.context
  sse_algorithm = "AES256"
}