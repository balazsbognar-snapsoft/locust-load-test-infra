output "global_state_manager_role_arn" {
  value = module.global_state_manager_role.role.arn
}

output "global_state_manager_ro_role_arn" {
  value = module.global_state_manager_role.ro_role.arn
}
