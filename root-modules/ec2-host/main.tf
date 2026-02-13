module "ec2-instance" {
  source = "../_component-modules/aws-ssm-jumpbox"

  context         = module.label_context.context
  region          = var.region
  organization_id = var.organization_id
  account_id      = var.account_id

  vpc_id                  = var.vpc_id
  subnet_id               = var.subnet_id
  add_interface_endpoints = false
  add_gateway_endpoints   = false

  instance_keeper = var.instance_keeper

  allow_http = false
  allow_ping = false

  # Egress security groups
  allow_all_egress   = false
  allow_http_egress  = true
  allow_https_egress = true

  security_group_ingress_rules = var.security_group_ingress_rules
  security_group_egress_rules  = var.security_group_egress_rules


  ami_id = var.ami_id

  iam_instance_profile_name = var.iam_instance_profile_name

  instance_type = var.instance_type

  user_data = var.user_data

}

