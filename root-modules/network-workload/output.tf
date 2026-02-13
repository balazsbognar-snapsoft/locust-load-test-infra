output "vpc_module_output" {
  value = module.vpc
}

output "vpc_endpoints_sg_id" {
  value = aws_security_group.vpc_endpoints.id
}

output "azs" {
  value = local.availability_zones
}