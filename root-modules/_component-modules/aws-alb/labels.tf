module "label_alb" {
  source        = "../null-label"
  context       = var.context
  resource_type = "alb"
}

module "label_alb_listener" {
  source        = "../null-label"
  context       = var.context
  resource_type = "alb-listener"
}

module "label_alb_listener_rule" {
  source        = "../null-label"
  context       = var.context
  resource_type = "alb-listener-rule"
}

module "label_alb_target_group" {
  for_each      = var.target_groups
  source        = "../null-label"
  context       = var.context
  name          = each.key
  resource_type = "alb-tg"
}

module "label_alb_sec_group" {
  source        = "../null-label"
  context       = var.context
  resource_type = "alb-sg"
}
