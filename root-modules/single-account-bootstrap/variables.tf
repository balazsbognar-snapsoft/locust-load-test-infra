variable "namespace" {
  type        = string
  description = "The namespace of the project, that will be prefixed on every resource."
}

variable "common_tags" {
  description = "The common tags, which should be applied to all resources"
  type        = map(string)
  default     = null
}

variable "state_bucket_account_id" {
  type        = string
  description = "The id of the account where the state bucket is exits"
}

variable "management_account_id" {
  type        = string
  description = "The id of the root account"
}

variable "region" {
  type        = string
  description = "Name of the region"
}

variable "initial_deployer_iam_user_name" {
  type        = string
  description = "The initial deployer IAM user name. If it is empty, then no permission are applied to the user."
  default     = ""
}

variable "management_workload_account_ids" {
  type        = list(string)
  description = "The account IDs for management workload resources (typically just the management account itself)"
  default     = []
}

variable "force_destroy" {
  type        = bool
  description = "Whether to force destroy the state bucket. If true, the state bucket will be destroyed even if it contains objects."
  default     = false
}
