resource "aws_security_group" "this" {
  name        = module.label_sg.id
  vpc_id      = var.vpc_id
  description = "Security group for jumpbox EC2."

  tags = module.label_sg.tags
}

resource "aws_security_group_rule" "icmp" {
  #checkov:skip=CKV_AWS_277: "Ensure no security groups allow ingress from 0.0.0.0:0 to port -1"
  count             = var.allow_ping ? 1 : 0
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
  description       = "Allow ICMP"
}

resource "aws_security_group_rule" "http" {
  #checkov:skip=CKV_AWS_260:Allows web traffic from anywhere TCP/80
  count             = var.allow_http ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
  description       = "Allow HTTP"
}

resource "aws_security_group_rule" "ec2_egress" {
  type              = "egress"
  count             = var.allow_all_egress ? 1 : 0
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
  description       = "Allow egress"
}

resource "aws_security_group_rule" "ec2_http_egress" {
  type              = "egress"
  count             = var.allow_http_egress ? 1 : 0
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
  description       = "Allow HTTP egress"
}

resource "aws_security_group_rule" "ec2_https_egress" {
  type              = "egress"
  count             = var.allow_https_egress ? 1 : 0
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this.id
  description       = "Allow HTTPS egress"
}

resource "aws_security_group_rule" "ec2_efs" {
  count             = length(var.efs_mounts) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
  protocol          = "tcp"
  description       = "Allow mount NFS"
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = var.security_group_ingress_rules != null ? var.security_group_ingress_rules : {}

  region = var.region

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  security_group_id            = aws_security_group.this.id
  to_port                      = try(coalesce(each.value.to_port, each.value.from_port), null)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = var.security_group_egress_rules != null ? var.security_group_egress_rules : {}

  region = var.region

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = try(coalesce(each.value.from_port, each.value.to_port), null)
  ip_protocol                  = each.value.ip_protocol
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  security_group_id            = aws_security_group.this.id
  to_port                      = each.value.to_port
}
