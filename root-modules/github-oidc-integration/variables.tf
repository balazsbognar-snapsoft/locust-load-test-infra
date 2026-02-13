variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "allowed_github_repositories" {
  type        = list(string)
  description = "List of GitHub repositories that are allowed to assume the role."
}
