resource "aws_cloudfront_vpc_origin" "this" {
  vpc_origin_endpoint_config {
    name                   = module.label_vpc_origin.id
    arn                    = var.vpc_origin_arn
    http_port              = var.http_port
    https_port             = var.https_port
    origin_protocol_policy = var.origin_protocol_policy

    origin_ssl_protocols {
      items    = var.origin_ssl_protocols.items
      quantity = var.origin_ssl_protocols.quantity
    }
  }
}