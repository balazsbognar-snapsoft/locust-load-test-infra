variable "region" {
  description = "The region where this module is deployed."
  type        = string
}

variable "namespace" {
  type        = string
  description = "The namespace of this module."
}

variable "environment" {
  type        = string
  description = "The environment of this module."
}

variable "name" {
  description = "The name of the CloudFront VPC origin endpoint configuration."
  type        = string
}

variable "vpc_origin_arn" {
  description = "The ARN of the CloudFront VPC origin endpoint configuration."
  type        = string
}

variable "http_port" {
  description = "The HTTP port for the CloudFront VPC origin endpoint configuration."
  type        = number
  default     = 80
}

variable "https_port" {
  description = "The HTTPS port for the CloudFront VPC origin endpoint configuration."
  type        = number
  default     = 443
}

variable "origin_protocol_policy" {
  description = "The origin protocol policy for the CloudFront VPC origin endpoint configuration."
  type        = string
  validation {
    condition     = contains(["http-only", "https-only", "match-viewer"], var.origin_protocol_policy)
    error_message = "Allowed values: http-only`, `https-only`, `match-viewer`."
  }
}

variable "origin_ssl_protocols" {
  description = "A complex type that contains information about the SSL/TLS protocols that CloudFront can use when establishing an HTTPS connection with your origin."
  type = object({
    items    = list(string)
    quantity = number
  })

  default = {
    items    = ["TLSv1.2"]
    quantity = 1
  }
}