variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "number_of_azs" {
  description = "Define how many availability zone to use"
  type        = number
}

variable "region" {
  type        = string
  description = "Region where to deploy resources"
}

variable "cidr_block" {
  description = "CIDR block of the vpc"
  type        = string
}

variable "public_subnets_cidr_block" {
  description = "CIDR blocks of public subnets"
  type        = list(string)
}

variable "private_subnets_cidr_block" {
  description = "CIDR blocks of private subnets"
  type        = list(string)
}

variable "database_subnets_cidr_block" {
  description = "CIDR blocks of database subnets"
  type        = list(string)
  default     = []
}

variable "redshift_subnets_cidr_block" {
  description = "CIDR blocks of database subnets"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = false
}

################################################################################
# Flow Log
################################################################################

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_destination_type" {
  description = "Type of flow log destination. Can be s3, kinesis-data-firehose or cloud-watch-logs"
  type        = string
  default     = "s3"
}

variable "flow_log_destination_arn" {
  description = "The ARN of the CloudWatch log group or S3 bucket where VPC Flow Logs will be pushed. If this ARN is a S3 bucket the appropriate permissions need to be set on that bucket's policy. When create_flow_log_cloudwatch_log_group is set to false this argument must be provided"
  type        = string
  default     = ""
}

variable "flow_log_file_format" {
  description = "(Optional) The format for the flow log. Valid values: `plain-text`, `parquet`"
  type        = string
  default     = null
}

variable "flow_log_per_hour_partition" {
  description = "(Optional) Indicates whether to partition the flow log per hour. This reduces the cost and response time for queries"
  type        = bool
  default     = false
}
