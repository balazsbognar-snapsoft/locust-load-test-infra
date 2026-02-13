variable "region" {
  type = string
}

variable "account_id" {
  type    = string
  default = ""
}


variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_ids" {
  type = list(string)
}

variable "trusted_principle_arns" {
  type        = list(string)
  description = "A list of AWS principal ARNs that are trusted to use the ECR KMS key."
  default     = []
}

variable "kms_key_name" {
  type        = string
  description = "Name to assign to the customer-managed KMS key used for ECR encryption."
}

variable "repositories" {
  type        = list(string)
  description = "A list of ECR repository names to create."
}
