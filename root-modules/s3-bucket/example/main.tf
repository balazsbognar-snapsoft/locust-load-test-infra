provider "aws" {
  region = "eu-central-1"
}

module "s3_bucket" {
  source = "../"

  region      = data.aws_caller_identity.current.account_id
  namespace   = "snapsoft"
  environment = "sandbox"

  name                            = "assets"
  sse_algorithm                   = "AES256"
  content_bucket_object_ownership = "BucketOwnerPreferred"
  content_bucket_public_access_block = {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
  bucket_key_enabled       = false
  blocked_encryption_types = ["NONE"]
  use_acl_for_content      = true
  s3_content_bucket_acp_grants = [
    # Enable bucket ACL to read files for everyone
    # {
    #   permission = "READ_ACP"
    #   grantee = {
    #     type = "Group"
    #     uri  = "http://acs.amazonaws.com/groups/global/AllUsers"
    #   }
    # }
  ]
  s3_content_bucket_cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = [
        "HEAD",
        "GET",
        "PUT",
        "POST",
        "DELETE"
      ],
      allowed_origins = ["*"],
      expose_headers = [
        "x-amz-server-side-encryption",
        "x-amz-request-id",
        "x-amz-id-2",
        "Origin",
        "X-Requested-With",
        "Content-Type",
        "Accept",
        "Authorization"
      ],
      max_age_seconds = 3000
    }
  ]

  transition_default_minimum_object_size = "varies_by_storage_class"

  lifecycle_configuration_for_content = {
    delete_incomplete_multipart_upload = {
      abort_incomplete_multipart_upload = 7
    },
    delete_noncurrent_versions_banner = {
      filter = {
        prefix = "banner/"
      }
      noncurrent_expiration = {
        days     = 90
        versions = 3
      }
    }
  }
}
