locals {
  hostname = var.hostname == null ? null : (var.hostname == "EC2_INSTANCE_RESOURCE_NAME" ? module.label_ec2_instance.id : var.hostname)
  read_amis = {
    amazon-linux-2023 = {
      image_id = data.aws_ami.amazon_linux_2023.image_id
      name     = data.aws_ami.amazon_linux_2023.name
    }
    ubuntu = {
      image_id = data.aws_ami.ubuntu.image_id
      name     = data.aws_ami.ubuntu.name
    }
  }
}

resource "null_resource" "ec2_redeploy_trigger" {
  triggers = {
    trigger = var.instance_keeper
  }
}

resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_135:The instance is not required to be EBS optimized
  ami                         = lookup(local.read_amis, var.ami_id, { image_id = var.ami_id }).image_id
  instance_type               = var.ami_id == "macos" ? var.macos_instance_type : var.instance_type
  iam_instance_profile        = var.iam_instance_profile_name != null ? var.iam_instance_profile_name : aws_iam_instance_profile.this[0].id
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip_address
  tenancy                     = var.ami_id == "macos" ? "host" : null
  host_id                     = var.ami_id == "macos" ? aws_ec2_host.mac[0].id : null

  user_data_replace_on_change = true
  user_data                   = var.user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_block_device_volume_size
    volume_type = var.root_block_device_volume_type
  }

  lifecycle {
    ignore_changes       = [ami]
    replace_triggered_by = [null_resource.ec2_redeploy_trigger]
  }

  depends_on = [
    module.endpoints
  ]

  tags = merge(
    module.label_ec2_instance.tags,
    var.network_tester_instance_enabled ? {
      Network_tester_enabled = true
    } : {}
  )

  volume_tags = module.label_ebs.tags
}

module "endpoints" {
  count  = var.add_interface_endpoints || var.add_gateway_endpoints ? 1 : 0
  source = "../aws-ssm-endpoints"

  region                                   = var.region
  organization_id                          = var.organization_id
  account_id                               = var.account_id
  context                                  = module.label_endpoints.context
  vpc_id                                   = var.vpc_id
  subnet_id                                = var.subnet_id
  add_interface_endpoints                  = var.add_interface_endpoints
  available_interface_endpoints            = var.available_interface_endpoints
  add_gateway_endpoints                    = var.add_gateway_endpoints
  s3_logging_bucket                        = var.ssm_s3_bucket_name
  enable_ecr_s3_bucket_readonly_permission = var.enable_ecr_s3_bucket_readonly_permission
}
