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

  lifecycle_configuration = {
    auto_archive = {
      abort_incomplete_multipart_upload = 7
      transitions = {
        short_term = {
          storage_class = "GLACIER_IR"
          days          = 7
        }
        long_term = {
          storage_class = "DEEP_ARCHIVE"
          days          = 180
        }
      }
      expiration = {
        days = 3653
      }
    }
    another_archive = {
      expiration = {
        days = 10
      }
    }
  }
}