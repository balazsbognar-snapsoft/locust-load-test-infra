module "vpc-origin-example" {
  source = "../"

  region      = data.aws_region.current.region
  namespace   = "snapsoft"
  environment = "sandbox"

  name                   = "ecs-internal-alb"
  vpc_origin_arn         = "arn:example" # CHANGEIT - ARN of the ALB
  origin_protocol_policy = "http-only"
  http_port              = 80
  https_port             = 443
  origin_ssl_protocols = {
    items    = ["TLSv1.2"]
    quantity = 1
  }
}