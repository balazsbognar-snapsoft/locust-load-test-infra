terraform {
  required_version = ">= v1.10.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.15.0"
    }
  }
}
