terraform {
  required_version = ">= v1.10.6"
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
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "config_log_bucket_kms" {
  //https://docs.aws.amazon.com/awscloudtrail/latest/userguide/default-kms-key-policy.html
  statement {
    sid = "Enable IAM User Permissions security tooling"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}
resource "aws_kms_key" "config_logs" {
  description             = "Test only"
  deletion_window_in_days = 30
  enable_key_rotation     = "true"
  policy                  = data.aws_iam_policy_document.config_log_bucket_kms.json
  tags                    = module.label_default_bucket.tags
}

module "config_log_s3_bucket" {
  source            = "../../"
  context           = module.label_default_bucket.context
  sse_algorithm     = "aws:kms"
  kms_master_key_id = aws_kms_key.config_logs.id
}
