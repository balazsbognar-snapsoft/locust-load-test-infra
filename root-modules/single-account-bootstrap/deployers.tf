
module "terraform_management_deployer_role" {
  source = "../_component-modules/aws-deploy-role"
  # providers = {
  #   aws = aws.management
  # }
  assumable_role_arns = concat(
    [for account_id in var.management_workload_account_ids : "arn:aws:iam::${account_id}:role/${module.label_management_workload_access_role.id}"],
    [
      "arn:aws:iam::${var.management_account_id}:role/${module.label_management_state_manager.id}",
      "arn:aws:iam::${var.management_account_id}:role/${module.label_management_ro_state_manager.id}",
    ]
  )
  context = module.label_management_deployer_role.context
  principals = {
    AWS = [
      var.initial_deployer_iam_user_name != "" ? "arn:aws:iam::${var.management_account_id}:user/${var.initial_deployer_iam_user_name}" : "" # TODO: remove after moving to github actions
    ]
  }
}
