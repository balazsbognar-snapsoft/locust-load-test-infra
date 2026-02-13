locals {
  root_module = "ec2-host"

  instance_keeper = "2026-02-04"
}

terraform {
  source = "../../../../../root-modules//${local.root_module}"
}

dependencies {
  paths = ["../network", "../../eu-central-1/master-host"]
}

dependency "network" {
  config_path = "../network"
}

dependency "master-host" {
  config_path = "../../eu-central-1/master-host"
}


inputs = {
  organization_id = "ou-123"
  account_id      = include.root.locals.account_id
  vpc_id          = dependency.network.outputs.vpc_module_output.vpc_id
  subnet_id       = dependency.network.outputs.vpc_module_output.private_subnets[0]
  ami_id          = "ubuntu"

  instance_name = "locust-worker-1"
  instance_type = "t4g.small"

  instance_custom_policies = []

  security_group_egress_rules = {
    allow_to_master = {
      from_port   = 5557
      to_port     = 5557
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.32.0/20"
    }
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

  sudo tee /root/locust/locustfile.py <<EOF
  from locust import HttpUser, task, between
  from locust.exception import StopUser

  class GoogleUser(HttpUser):
      # Várakozási idő a kérések között (pl. 1 és 3 másodperc között véletlenszerűen)
      wait_time = between(1, 3)

      # Alapértelmezett host (ezt parancssorból is felülírhatod)
      host = "https://www.google.com"

      # Számláló inicializálása
      request_count = 0

      @task
      def load_homepage(self):
          # Ellenőrizzük, elértük-e a limitet
          if self.request_count >= 3:
              # Ha megvolt a 3, leállítjuk ezt a felhasználót
              raise StopUser()

          # A tényleges kérés
          with self.client.get("/", catch_response=True) as response:
              if response.status_code == 200:
                  response.success()
              else:
                  response.failure(f"Hiba: {response.status_code}")

          # Növeljük a számlálót
          self.request_count += 1
          print(f"Kérés elküldve: {self.request_count}. alkalom")
  EOF

  sudo tee /root/locust/docker-compose.yaml <<EOF
  services:
    worker:
      image: locustio/locust
      restart: unless-stopped
      deploy:
        replicas: 2
      volumes:
        - ./:/mnt/locust
      command: -f /mnt/locust/locustfile.py --worker --master-host ${dependency.master-host.outputs.ec2_instance.private_ip}
  EOF

  docker compose up -d
  EOL
}

include "root" {
  expose = true
  path   = find_in_parent_folders("root.hcl")
}
