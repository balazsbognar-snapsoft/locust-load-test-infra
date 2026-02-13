locals {
  root_module = "network-workload"
}

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

inputs = {
  number_of_azs              = 2
  cidr_block                 = "10.0.16.0/20"
  public_subnets_cidr_block  = ["10.0.16.0/27", "10.0.16.32/27"]
  private_subnets_cidr_block = ["10.0.17.0/26", "10.0.17.64/26"]
  enable_nat_gateway         = true
  single_nat_gateway         = true
  one_nat_gateway_per_az     = false

  # Flow log configuration
  enable_flow_log             = false
  flow_log_destination_type   = "s3"
  flow_log_destination_arn    = "arn:aws:s3:::clienttether-dev-vpc-flow-log-s3-bucket"
  flow_log_file_format        = "parquet"
  flow_log_per_hour_partition = true
}

include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
