data "aws_caller_identity" "this" {}

module "label_context" {
  source      = "../../null-label"
  namespace   = "snapsoft"
  environment = "sandbox"
}

module "label_state_manager_role" {
  source        = "../../null-label"
  context       = module.label_context.context
  environment   = "test"
  name          = "state-manager"
  resource_type = "iam-policy"
}

resource "aws_s3_bucket" "terraform_s3_bucket" {

  bucket_prefix = "terraform-"
  acl           = "private"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = merge(module.label_context.tags, { Name = "terraform-" })
}

module "test_state_manager_role" {
  source                = "../"
  context               = module.label_state_manager_role.context
  paths                 = ["test/*"]
  s3_backend_bucket_arn = aws_s3_bucket.terraform_s3_bucket.arn
  common_tags           = module.label_context.tags
  principals = {
    AWS = [
      "arn:aws:iam::${data.aws_caller_identity.this.id}:root"
    ]
  }
  kms_key_arn = "*"
}
