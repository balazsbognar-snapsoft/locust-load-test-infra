output "module_output" {
  value = {
    s3_vpc_flow_log_bucket = module.vpc_flow_log_bucket
    network                = module.network
    rds_bastion_instance   = module.rds_bastion_instance
  }
}
