module "label_test" {
  source = "../../"
}
module "label_prod_context" {
  source        = "../../"
  namespace     = "sre"
  environment   = "prod"
  resource_type = "ec2-instance"
}
module "label_dev_context" {
  source        = "../../"
  namespace     = "sre"
  environment   = "dev"
  resource_type = "ec2-instance"
}
module "label_global_no_tag_inheritance" {
  source        = "../../"
  namespace     = "sre"
  environment   = "prod"
  name          = "dont-inherit-backup"
  resource_type = "sas"
}
module "label_ec2_prod" {
  source        = "../../"
  context       = module.label_prod_context.context
  name          = "ec2-test"
  resource_type = "ec2-instance"
}
module "label_rds_prod" {
  source        = "../../"
  context       = module.label_prod_context.context
  name          = "rds-test"
  resource_type = "rds-cluster"
}
module "label_efs_prod" {
  source        = "../../"
  context       = module.label_prod_context.context
  name          = "test-efs"
  resource_type = "file-system"
}
module "label_ec2_dev" {
  source        = "../../"
  context       = module.label_dev_context.context
  name          = "ec2-test"
  resource_type = "ec2-instance"
}
module "label_rds_dev" {
  source        = "../../"
  context       = module.label_dev_context.context
  name          = "rds-test"
  resource_type = "rds-cluster"

}

module "label_efs_dev" {
  source        = "../../"
  context       = module.label_dev_context.context
  name          = "test-efs"
  resource_type = "file-system"
}
terraform {
  required_version = ">= v1.10.6"
}

output "label_prod_context" {
  value = {
    id   = module.label_prod_context.id
    tags = module.label_prod_context.tags
  }
}

output "label_dev_context" {
  value = {
    id   = module.label_dev_context.id
    tags = module.label_dev_context.tags
  }
}

output "label_non_inherit" {
  value = {
    id   = module.label_global_no_tag_inheritance.id
    tags = module.label_global_no_tag_inheritance.tags
  }
}

output "label_prod_ec2" {
  value = {
    id   = module.label_ec2_prod.id
    tags = module.label_ec2_prod.tags
  }
}

output "label_prod_rds" {
  value = {
    id   = module.label_rds_prod.id
    tags = module.label_rds_prod.tags
  }
}
output "label_prod_efs" {
  value = {
    id   = module.label_efs_prod.id
    tags = module.label_efs_prod.tags
  }
}

output "label_dev_ec2" {
  value = {
    id   = module.label_ec2_dev.id
    tags = module.label_ec2_dev.tags
  }
}

output "label_dev_rds" {
  value = {
    id   = module.label_rds_dev.id
    tags = module.label_rds_dev.tags
  }
}
output "label_dev_efs" {
  value = {
    id   = module.label_efs_dev.id
    tags = module.label_efs_dev.tags
  }
}
output "label_prod_context_context" {
  value = module.label_prod_context.context
}
output "label_test" {
  value = module.label_test.context
}

module "label_rds_dev_label_order_test" {
  source      = "../../"
  context     = module.label_rds_dev.context
  label_order = ["name", "resource_type"]

}

output "label_rds_dev_label_order_test" {
  value = {
    id  = module.label_rds_dev_label_order_test.id
    tag = module.label_rds_dev_label_order_test.tags
  }
}

module "label_rds_dev_label_order_test_inherit_label_order" {
  source  = "../../"
  context = module.label_rds_dev_label_order_test.context

}
output "label_rds_dev_label_order_test_inherit_label_order" {
  value = {
    id  = module.label_rds_dev_label_order_test_inherit_label_order.id
    tag = module.label_rds_dev_label_order_test_inherit_label_order.tags
  }
}