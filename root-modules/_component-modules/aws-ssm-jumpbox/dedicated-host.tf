data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "aws_ec2_host" "mac" {
  count             = var.ami_id == "macos" ? 1 : 0
  availability_zone = data.aws_subnet.this.availability_zone
  instance_type     = var.macos_instance_type
  tags              = module.label_mac_host.tags
}
