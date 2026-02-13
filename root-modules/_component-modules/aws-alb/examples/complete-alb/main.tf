locals {
  availability_zones = toset(slice(data.aws_availability_zones.azs.names, 0, 2))
}

##################################################################
# VPC
##################################################################
module "vpc" {
  source               = "../../../aws-network"
  create_vpc           = true
  region               = "eu-central-1"
  name                 = module.vpc_label.id_full
  cidr                 = "10.16.0.0/16"
  azs                  = local.availability_zones
  enable_dns_hostnames = true
  enable_dns_support   = true
  vpc_tags             = module.vpc_label.tags

  # IGW
  create_igw = true
  igw_tags   = module.igw_label.tags

  # Public Subnets
  public_subnets      = ["10.16.128.0/26", "10.16.136.0/26"]
  public_subnet_names = [for subnet in module.public_subnet_label : subnet.id_full]

  # Public route table
  public_route_table_tags = module.public_rt_label.tags

  manage_default_network_acl = false
  manage_default_route_table = false
}
##################################################################
# Application Load Balancer
##################################################################

module "alb" {
  source = "../../"


  context = module.example_context_label.context
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # For example only
  enable_deletion_protection = false

  create_security_group = true

  security_group_name = module.label_alb_sec_group.id

  security_group_ingress_rules = {
    allow_from_cloudfront = {
      description    = "CloudFront IPs"
      from_port      = 80
      to_port        = 80
      ip_protocol    = "tcp"
      prefix_list_id = "pl-a3a144ca" # Prefix list IDs of Cloudfront distribution IPs
    }
  }

  security_group_egress_rules = {
    allow_to_frontend = {
      from_port   = 5678
      to_port     = 5678
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    allow_to_backend = {
      from_port   = 8080
      to_port     = 8080
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # access_logs = {
  #   bucket = module.log_bucket.s3_bucket_id
  #   prefix = "access-logs"
  # }

  # connection_logs = {
  #   bucket  = module.log_bucket.s3_bucket_id
  #   enabled = true
  #   prefix  = "connection-logs"
  # }

  client_keep_alive = 3600

  listeners = {
    ecs-frontend-rule = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Not found"
        status_code  = 404
      }
      rules = {
        forward-to-frontend = {
          priority = 1
          actions = [{
            forward = {
              target_group_key = "ecs-frontend"
            }
          }]

          conditions = [{
            host_header = {
              values       = ["frontend.dev.lemontaps.com"]
              regex_values = null
            }
          }]
        }
      }
    }
    ecs-backend-rule = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Not found"
        status_code  = 404
      }
      rules = {
        forward-to-backend = {
          priority = 2
          actions = [{
            forward = {
              target_group_key = "ecs-backend"
            }
          }]

          conditions = [{
            host_header = {
              values       = ["backend.dev.lemontaps.com"]
              regex_values = null
            }
          }]
        }
      }
    }
  }

  target_groups = {
    ecs-frontend = {
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      deregistration_delay              = 300
      load_balancing_algorithm_type     = "round_robin"
      load_balancing_anomaly_mitigation = "off"
      load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP2"
      target_id        = null
      port             = 5678
    }
    ecs-backend = {
      name                              = "ecs-backend-target-group"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      deregistration_delay              = 300
      load_balancing_algorithm_type     = "round_robin"
      load_balancing_anomaly_mitigation = "off"
      load_balancing_cross_zone_enabled = "use_load_balancer_configuration"

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP2"
      target_id        = null
      port             = 8080
    }
  }

  additional_target_group_attachments = {
  }

  # Route53 Record(s)
  route53_records = {
  }
}
