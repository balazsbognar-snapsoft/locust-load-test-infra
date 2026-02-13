locals {
  root_module = "_component-modules/aws-vpc-peering"

  origin_region = "${include.root.locals.region}"

  peer_region = "eu-west-1"

  account_id = "${include.root.locals.account_id}"

  role_arn = "arn:aws:iam::${include.root.locals.account_id}:role/${include.root.locals.terraform_role_to_assume}"
}

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

dependencies {
  paths = ["../network", "../../eu-west-1/network"]
}

dependency "network" {
  config_path = "../network"
}

dependency "network_peer" {
  config_path = "../../eu-west-1/network"
}

inputs = {
  enable_vpc_peering          = true
  vpc_peering_connection_name = "eu-west-central"

  requestor_vpc_id = dependency.network.outputs.vpc_module_output.vpc_id

  acceptor_vpc_id = dependency.network_peer.outputs.vpc_module_output.vpc_id

  peering_region = local.peer_region

}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents = templatefile("providers.tmpl", {
    region       = include.root.locals.region
    peer_region  = local.peer_region
    role_arn     = local.role_arn
    default_tags = "${length(path_relative_to_include()) > 256 ? format("...%s", substr(path_relative_to_include(), -252, -1)) : path_relative_to_include()}"
  })
}

include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
