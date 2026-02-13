provider "aws" {
  region = "eu-central-1"
}



module "ecr" {
  source = "../../"

  region     = data.aws_region.current.region
  account_id = data.aws_caller_identity.current.account_id

  account_ids = [data.aws_caller_identity.current.account_id]

  trusted_principle_arns = ["arn:aws:iam::123456789012:role/testing-instance"]

  kms_key_name = "example-ecr-key"

  namespace   = "test"
  environment = "sandbox"

  repositories = [
    "lemontaps-webapp",
    "lemontaps-api"
  ]
}
