resource "aws_security_group" "this" {
  count = var.add_interface_endpoints ? 1 : 0

  name        = module.label_sg[0].id
  vpc_id      = var.vpc_id
  description = "Security group for SSM required VPC endpoints."

  tags = module.label_sg[0].tags
}

resource "aws_security_group_rule" "ingress" {
  count = var.add_interface_endpoints ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this[0].id
  description       = "HTTPS port"
}

resource "aws_security_group_rule" "egress" {
  count = var.add_interface_endpoints ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.this[0].id
  description       = "Allow egress"
}

locals {
  required_interface_endpoint_services = {
    ssm         = "com.amazonaws.${var.region}.ssm",
    ssmmessages = "com.amazonaws.${var.region}.ssmmessages",
    ec2messages = "com.amazonaws.${var.region}.ec2messages",
    logs        = "com.amazonaws.${var.region}.logs",
    kms         = "com.amazonaws.${var.region}.kms"
  }
  interface_endpoint_services = { for k, v in local.required_interface_endpoint_services :
  k => v if !contains(var.available_interface_endpoints, k) }

  gateway_endpoint_policies = {
    s3 = data.aws_iam_policy_document.s3_gateway_policy.json
  }

  gateway_endpoint_services = {
    s3 = "com.amazonaws.${var.region}.s3"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.add_interface_endpoints ? local.interface_endpoint_services : {}

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = [var.subnet_id]
  security_group_ids  = [aws_security_group.this[0].id]

  tags = merge(module.label_interface_endpoint[each.key].tags,
    {
      Endpoint_type = replace(each.key, "_", "-")
    }
  )

}

resource "aws_vpc_endpoint" "gateway" {
  for_each = var.add_gateway_endpoints ? local.gateway_endpoint_services : {}

  policy            = lookup(local.gateway_endpoint_policies, each.key, null)
  vpc_id            = var.vpc_id
  service_name      = each.value
  vpc_endpoint_type = "Gateway"

  tags = merge(module.label_gateway_endpoint[each.key].tags,
    {
      Endpoint_type = "${replace(each.key, "_", "-")}-gateway"
    }
  )

}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_route_tables" "this" {
  vpc_id = var.vpc_id

  filter {
    name   = "association.subnet-id"
    values = [var.subnet_id]
  }
}

resource "aws_vpc_endpoint_route_table_association" "gateway" {
  for_each = var.add_gateway_endpoints ? local.gateway_endpoint_services : {}

  route_table_id  = length(data.aws_route_tables.this.ids) > 0 ? data.aws_route_tables.this.ids[0] : data.aws_vpc.this.main_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.gateway[each.key].id
}
