locals {
  project     = "clienttether"
  environment = "dev"

  tags = {
    environment = local.environment
  }
  backend_iam_role_name    = "${local.project}-${local.environment}-state-manager-iam-role"
  backend_ro_iam_role_name = "${local.project}-${local.environment}-state-manager-ro-iam-role"
  deploy_iam_role_name     = "${local.project}-${local.environment}-terraform-deployer-iam-role"
}
