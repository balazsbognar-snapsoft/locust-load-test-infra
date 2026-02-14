locals {
  root_module = "ec2-host"

  instance_keeper = "2026-02-04"
}

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  organization_id = "ou-123"
  account_id      = include.root.locals.account_id
  vpc_id          = dependency.network.outputs.vpc_module_output.vpc_id
  subnet_id       = dependency.network.outputs.vpc_module_output.private_subnets[0]
  ami_id          = "ubuntu"

  instance_name = "locust-master"
  instance_type = "t4g.small"

  security_group_ingress_rules = {
    allow_from_vpc = {
      description = "Allow_port_to_communicate"
      from_port   = 5557
      to_port     = 5557
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/8"
    }
  }

  security_group_egress_rules = {
  }

  instance_custom_policies = [
    {
      sid = "AllowECRAuthTokenAccess"
      effect = "Allow"
      actions = ["ecr:GetAuthorizationToken"]
      resources = ["*"]
    }
  ]

  additional_tags = {
    Role = "locust-master"
    Application = "locust"
  }

  user_data = <<-EOL
  #!/bin/bash -xe

  # Instance keeper ${local.instance_keeper}

  sudo apt update
  sudo apt install ca-certificates curl -y
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
  Types: deb
  URIs: https://download.docker.com/linux/ubuntu
  Suites: noble
  Components: stable
  Signed-By: /etc/apt/keyrings/docker.asc
  EOF

  sudo apt update

  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin unzip -y

  sudo systemctl enable --now docker

  sudo mkdir -p /root/locust && cd /root/locust

  sudo tee /root/locust/.env <<EOF
  AWS_REGION: "eu-central-1"
  ECR_REGISTRY: "563149050409.dkr.ecr.eu-central-1.amazonaws.com"
  ARTIFACT_REPO: "locust-artifacts"
  ARTIFACT_TAG: "v0.0.1"
  EOF


  sudo tee /root/locust/docker-compose.yaml <<EOF
  services:
    init-downloader:
      image: 563149050409.dkr.ecr.eu-central-1.amazonaws.com/locust-tester:v0.0.3
      container_name: init-downloader
      env_file: .env
      volumes:
        - locust-scripts:/locust-data
      command: >
        sh -c "
          echo 'Logging into ECR...'
          aws ecr get-login-password --region $AWS_REGION | oras login --username AWS --password-stdin $ECR_REGISTRY &&
          echo 'Pulling artifact...'
          oras pull $ECR_REGISTRY/$ARTIFACT_REPO:$ARTIFACT_TAG &&
          echo 'Unpacking...'
          tar -xzf locust-tests.tar.gz -C /locust-data &&
          echo 'Done!'
        "
      master:
        image: 563149050409.dkr.ecr.eu-central-1.amazonaws.com/locust-perftester:latest
        restart: unless-stopped
        deploy:
          replicas: 1
        ports:
          - "8089:8089"
          - "5557:5557"
        volumes:
          - locust-scripts:/mnt/locust
        command: -f /mnt/locust/locustfile.py --master -H http://master:8089
        depends_on:
          init-downloader:
            condition: service_completed_successfully

  volumes:
    locust-scripts: # Ephemeral volume
  EOF

  docker compose up -d
  EOL
}

include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
