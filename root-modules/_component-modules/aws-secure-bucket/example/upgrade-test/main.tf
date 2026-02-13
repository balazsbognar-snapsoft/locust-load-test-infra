provider "aws" {
  profile = "snapsoft-sandbox-2"
}
resource "aws_kms_key" "test" {

}
module "terraform_internal_state_secure_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_internal_state_bucket_s3_bucket.context
  sse_algorithm                  = "aws:kms"
  kms_master_key_id              = aws_kms_key.test.arn
}
module "terraform_state_secure_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_state_bucket_s3_bucket.context
  sse_algorithm                  = "aws:kms"
  kms_master_key_id              = aws_kms_key.test.arn
}
module "platform_state_secure_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_platform_state_bucket_s3_bucket.context
  sse_algorithm                  = "aws:kms"
  kms_master_key_id              = aws_kms_key.test.arn
}

module "config_log_s3_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_config_log_bucket.context
  sse_algorithm                  = "aws:kms"
  kms_master_key_id              = aws_kms_key.test.arn

  lifecycle_configuration = var.s3_archive_log_lifecycle
}

module "ssm_logs_s3_bucket" {
  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_ssm_logs_s3_bucket.context
  sse_algorithm                  = "AES256"

  lifecycle_configuration = var.s3_archive_log_lifecycle
}

module "organization_msk_logs_s3_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_msk_bucket.context
  sse_algorithm                  = "aws:kms"
  kms_master_key_id              = aws_kms_key.test.arn

  lifecycle_configuration = var.s3_archive_log_lifecycle
}


module "organization_trail_s3_bucket" {

  source                         = "../../"
  use_acl_for_access_logs        = true
  migration_from_old_s3_defaults = false
  context                        = module.label_organization_trail_s3_bucket.context
  sse_algorithm                  = "AES256"

  object_lock_configuration = {
    enabled = true
    mode    = "COMPLIANCE"
    years   = null
    days    = 5
  }

  lifecycle_configuration = var.s3_archive_log_lifecycle
}


locals {
  resource_type = {
    aws_kms_key           = "kms-cmk"
    aws_s3_bucket         = "s3-bucket"
    aws_iam_role          = "iam-role"
    aws_config_aggregator = "config-aggregator"
    aws_sns_topic         = "sns-topic"
    aws_access_analyzer   = "access-analyzer"
    aws_cloudtrail        = "cloudtrail"
    aws_log_group         = "log-group"
    aws_iam_policy        = "iam-policy"
    aws_iam_user          = "iam-user"
  }
  //This uses kebab-case to equal the tag name
  protection-level = {
    immutable = "IMMUTABLE"
    protected = "PROTECTED"
  }
}

import {
  to = module.config_log_s3_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-config-logs-s3-bucket"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-config-logs-access-log-s3-bucket"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-config-logs-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-config-logs-access-log-s3-bucket"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-config-logs-s3-bucket"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-config-logs-s3-bucket"
}
import {
  to = module.config_log_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey["sse_algorithm"]
  id = "snapsoft-sbxg-config-logs-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-msk-logs-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-msk-logs-access-log-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-msk-logs-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-msk-logs-access-log-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-msk-logs-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-msk-logs-s3-bucket"
}
import {
  to = module.organization_msk_logs_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey["sse_algorithm"]
  id = "snapsoft-sbxg-msk-logs-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-platform-state-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-platform-state-access-log-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-platform-state-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-platform-state-access-log-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-platform-state-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-platform-state-s3-bucket"
}
import {
  to = module.platform_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey["sse_algorithm"]
  id = "snapsoft-sbxg-platform-state-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-ssm-baseline-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-ssm-baseline-access-log-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-ssm-baseline-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-ssm-baseline-access-log-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-ssm-baseline-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-ssm-baseline-s3-bucket"
}
import {
  to = module.ssm_logs_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.content_aes["sse_algorithm"]
  id = "snapsoft-sbxg-ssm-baseline-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-internal-state-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-internal-state-access-log-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-internal-state-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-internal-state-access-log-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-internal-state-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-internal-state-s3-bucket"
}
import {
  to = module.terraform_internal_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey["sse_algorithm"]
  id = "snapsoft-sbxg-internal-state-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-terraform-state-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-terraform-state-access-log-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-terraform-state-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-terraform-state-access-log-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-terraform-state-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-terraform-state-s3-bucket"
}
import {
  to = module.terraform_state_secure_bucket.aws_s3_bucket_server_side_encryption_configuration.content_kms_masterkey["sse_algorithm"]
  id = "snapsoft-sbxg-terraform-state-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_lifecycle_configuration.content["auto_archive"]
  id = "snapsoft-sbxg-organization-trail-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_lifecycle_configuration.access_log["auto_archive"]
  id = "snapsoft-sbxg-organization-trail-access-log-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_acl.access_log[0]
  id = "snapsoft-sbxg-organization-trail-access-log-s3-bucket,log-delivery-write"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.access_log
  id = "snapsoft-sbxg-organization-trail-access-log-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_logging.content
  id = "snapsoft-sbxg-organization-trail-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_versioning.content
  id = "snapsoft-sbxg-organization-trail-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_server_side_encryption_configuration.content_aes["sse_algorithm"]
  id = "snapsoft-sbxg-organization-trail-s3-bucket"
}
import {
  to = module.organization_trail_s3_bucket.aws_s3_bucket_object_lock_configuration.content_days["enabled"]
  // this will be years in the real
  id = "snapsoft-sbxg-organization-trail-s3-bucket"
}


#output "outputs" {
#  value = {
#    config                                 = module.config_log_s3_bucket.template
#    trail                                  = module.organization_trail_s3_bucket.template
#    terraform_internal_state_secure_bucket = module.terraform_internal_state_secure_bucket.template
#    terraform_state_secure_bucket          = module.terraform_state_secure_bucket.template
#    platform_state_secure_bucket           = module.platform_state_secure_bucket.template
#    ssm_logs_s3_bucket                     = module.ssm_logs_s3_bucket.template
#    organization_msk_logs_s3_bucket        = module.organization_msk_logs_s3_bucket.template
#  }
#}




