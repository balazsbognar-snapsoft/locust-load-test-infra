locals {
  resource_type = {
    aws_kms_key                = "kms-cmk"
    aws_s3_bucket              = "s3-bucket"
    aws_iam_role               = "iam-role"
    aws_config_aggregator      = "config-aggregator"
    aws_sns_topic              = "sns-topic"
    aws_access_analyzer        = "access-analyzer"
    aws_unused_access_analyzer = "unused-access-analyzer"
    aws_cloudtrail             = "cloudtrail"
    aws_log_group              = "log-group"
    aws_iam_policy             = "iam-policy"
    aws_iam_user               = "iam-user"
  }
  //This uses kebab-case to equal the tag name
  protection-level = {
    immutable = "IMMUTABLE"
    protected = "PROTECTED"
  }
}
