# Get architecture type dynamically based on the instance type
data "aws_ec2_instance_type" "selected" {
  instance_type = var.instance_type
}

locals {
  architecture = length(data.aws_ec2_instance_type.selected.supported_architectures) > 0 ? data.aws_ec2_instance_type.selected.supported_architectures[0] : "x86_64" # Default fallback
}

# Ubuntu AMI selection based on architecture
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = local.architecture == "arm64" ? ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"] : ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["099720109477"]
}

# Amazon Linux 2 AMI selection based on architecture
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = local.architecture == "arm64" ? ["amzn2-ami-hvm-*-arm64*"] : ["amzn2-ami-hvm-*-x86_64*"]
  }

  owners = ["137112412989"] # AWS
}

data "aws_ami" "macos" {
  count       = var.ami_id == "macos" ? 1 : 0
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.macos_image_name_prefix}*"]
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-${var.AL2023_version_selector}"]
  }
  filter {
    name   = "architecture"
    values = [local.architecture]
  }

  owners = ["137112412989"] # AWS
}