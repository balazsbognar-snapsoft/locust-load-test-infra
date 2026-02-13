module "label_aws_ecr_repository" {
  source        = "../null-label"
  context       = var.context
  resource_type = "ecr-repository"
}