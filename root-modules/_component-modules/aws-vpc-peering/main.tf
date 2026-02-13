locals {
  requestor_cidr_blocks = module.label_vpc_peering.enabled ? tolist(setsubtract([
    for k, v in data.aws_vpc.requestor[0].cidr_block_associations : v.cidr_block
  ], var.requestor_ignore_cidrs)) : []
  acceptor_cidr_blocks = module.label_vpc_peering.enabled ? tolist(setsubtract([
    for k, v in data.aws_vpc.acceptor[0].cidr_block_associations : v.cidr_block
  ], var.acceptor_ignore_cidrs)) : []
}

resource "aws_vpc_peering_connection" "default" {
  provider    = aws.default
  vpc_id      = join("", data.aws_vpc.requestor[*].id)
  peer_vpc_id = join("", data.aws_vpc.acceptor[*].id)
  peer_region = var.peering_region


  auto_accept = false


  lifecycle {
    enabled = module.label_vpc_peering.enabled
  }

  tags = module.label_vpc_peering.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

}

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = aws.peer

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
  auto_accept               = true

  tags = module.label_vpc_peering_accepter.tags
}

resource "aws_vpc_peering_connection_options" "requester" {
  provider                  = aws.default
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.peer]
}

# Accepter oldali beállítások (Peer régió)
resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.peer

  vpc_peering_connection_id = aws_vpc_peering_connection.default.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.peer]
}

# Lookup requestor VPC so that we can reference the CIDR
data "aws_vpc" "requestor" {
  provider = aws.default
  count    = module.label_vpc_peering.enabled ? 1 : 0
  id       = var.requestor_vpc_id
  tags     = var.requestor_vpc_tags
}

# Lookup acceptor VPC so that we can reference the CIDR
data "aws_vpc" "acceptor" {
  provider = aws.peer
  count    = module.label_vpc_peering.enabled ? 1 : 0
  id       = var.acceptor_vpc_id
  tags     = var.acceptor_vpc_tags
}

data "aws_route_tables" "requestor" {
  provider = aws.default
  count    = module.label_vpc_peering.enabled ? 1 : 0
  vpc_id   = join("", data.aws_vpc.requestor[*].id)
  tags     = var.requestor_route_table_tags
}

data "aws_route_tables" "acceptor" {
  provider = aws.peer
  count    = module.label_vpc_peering.enabled ? 1 : 0
  vpc_id   = join("", data.aws_vpc.acceptor[*].id)
  tags     = var.acceptor_route_table_tags
}

# Create routes from requestor to acceptor
resource "aws_route" "requestor" {
  provider                  = aws.default
  count                     = module.label_vpc_peering.enabled ? length(distinct(sort(data.aws_route_tables.requestor[0].ids))) * length(local.acceptor_cidr_blocks) : 0
  route_table_id            = element(distinct(sort(data.aws_route_tables.requestor[0].ids)), ceil(count.index / length(local.acceptor_cidr_blocks)))
  destination_cidr_block    = local.acceptor_cidr_blocks[count.index % length(local.acceptor_cidr_blocks)]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default[*].id)
  depends_on                = [data.aws_route_tables.requestor, aws_vpc_peering_connection.default]
}

# Create routes from acceptor to requestor
resource "aws_route" "acceptor" {
  provider                  = aws.peer
  count                     = module.label_vpc_peering.enabled ? length(distinct(sort(data.aws_route_tables.acceptor[0].ids))) * length(local.requestor_cidr_blocks) : 0
  route_table_id            = element(distinct(sort(data.aws_route_tables.acceptor[0].ids)), ceil(count.index / length(local.requestor_cidr_blocks)))
  destination_cidr_block    = local.requestor_cidr_blocks[count.index % length(local.requestor_cidr_blocks)]
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.default[*].id)
  depends_on                = [data.aws_route_tables.acceptor, aws_vpc_peering_connection.default]
}
