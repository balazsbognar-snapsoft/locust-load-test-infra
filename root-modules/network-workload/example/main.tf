provider "aws" {
  region = "eu-central-1"
}

module "vpc_flow_log_bucket" {
  source = "../../s3-bucket-for-logs"

  region      = data.aws_region.current.region
  namespace   = "snapsoft"
  environment = "sandbox"

  name = "vpc-flow"
  custom_iam_statements = [
    {
      sid    = "VPCFlowLogDeliveryWrite"
      effect = "Allow"
      principals = [
        {
          type = "Service"
          identifiers = [
            "delivery.logs.amazonaws.com"
          ]
        }
      ]
      actions = [
        "s3:PutObject"
      ]
      resources = [
        "arn:aws:s3:::snapsoft-sandbox-vpc-flow-access-log-s3-bucket/*"
      ]
      conditions = [
        {
          test     = "StringEquals"
          values   = ["bucket-owner-full-control"]
          variable = "s3:x-amz-acl"
        },
        {
          test     = "StringEquals"
          values   = [data.aws_caller_identity.current.account_id]
          variable = "aws:SourceAccount"
        },
        {
          test     = "ArnLike"
          values   = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:*"]
          variable = "aws:SourceArn"
        }
      ]
    },
    {
      sid    = "VPCFlowLogDeliveryAclCheck"
      effect = "Allow"
      principals = [
        {
          type = "Service"
          identifiers = [
            "delivery.logs.amazonaws.com"
          ]
        }
      ]
      actions = [
        "s3:GetBucketAcl"
      ]
      resources = [
        "arn:aws:s3:::snapsoft-sandbox-vpc-flow-access-log-s3-bucket",
      ]
      conditions = [
        {
          test     = "StringEquals"
          values   = [data.aws_caller_identity.current.account_id]
          variable = "aws:SourceAccount"
        },
        {
          test     = "ArnLike"
          values   = ["arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:*"]
          variable = "aws:SourceArn"
        }
      ]
    }
  ]
}

module "network" {
  source = "../"

  region      = data.aws_region.current.region
  namespace   = "snapsoft"
  environment = "sandbox"

  number_of_azs               = 2
  cidr_block                  = "10.16.0.0/17"
  public_subnets_cidr_block   = ["10.16.0.0/26", "10.16.16.0/26"]
  private_subnets_cidr_block  = ["10.16.4.0/23", "10.16.20.0/23"]
  database_subnets_cidr_block = ["10.16.6.0/28", "10.16.22.0/28"]
  enable_nat_gateway          = true
  single_nat_gateway          = false
  one_nat_gateway_per_az      = true

  # Flow log configuration
  enable_flow_log             = false
  flow_log_destination_type   = "s3"
  flow_log_destination_arn    = "arn:aws:s3:::snapsoft-sandbox-vpc-flow-access-log-s3-bucket"
  flow_log_file_format        = "parquet"
  flow_log_per_hour_partition = true
}
