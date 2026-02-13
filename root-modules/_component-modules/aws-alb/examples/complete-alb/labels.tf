module "example_context_label" {
  source    = "../../../null-label"
  namespace = "example"
}

module "vpc_label" {
  source = "../../../null-label"

  context = module.example_context_label.context
  name    = "main-vpc"

}

module "igw_label" {
  source = "../../../null-label"

  context = module.example_context_label.context
  name    = "igw"

}

module "public_subnet_label" {
  source = "../../../null-label"

  for_each = local.availability_zones

  context = module.example_context_label.context
  name    = "public-subnet-${each.key}"

}

module "public_rt_label" {
  source = "../../../null-label"

  context = module.example_context_label.context
  name    = "public-rt"

}

module "label_alb_sec_group" {
  source        = "../../../null-label"
  context       = module.example_context_label.context
  name          = "alb"
  resource_type = "security-group"
}
