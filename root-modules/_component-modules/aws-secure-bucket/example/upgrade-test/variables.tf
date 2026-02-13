
variable "common_tags" {
  description = "The common tags, which should be applied to all resources"
  type        = map(string)
  default     = { test = "test" }
}

variable "s3_archive_log_lifecycle" {
  description = "default"
  default = {
    auto_archive = {
      abort_incomplete_multipart_upload = 7
      transitions = {
        short_term = {
          storage_class = "GLACIER_IR"
          days          = 7
        }
        long_term = {
          storage_class = "DEEP_ARCHIVE"
          days          = 180
        }
      }
      expiration = {
        days = 3653
      }
    }
  }
}
