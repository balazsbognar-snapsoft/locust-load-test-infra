output "id" {
  value       = local.enabled ? local.id : ""
  description = "Disambiguated ID string restricted to `id_length_limit` characters in total"
}

output "id_full" {
  value       = local.enabled ? local.id_full : ""
  description = "ID string not restricted in length"
}

output "enabled" {
  value       = local.enabled
  description = "True if module is enabled, false otherwise"
}

output "namespace" {
  value       = local.enabled ? local.namespace : ""
  description = "Normalized namespace"
}

output "resource_type" {
  value       = local.enabled ? local.resource_type : ""
  description = "Normalized resource_type"
}

output "environment" {
  value       = local.enabled ? local.environment : ""
  description = "Normalized environment"
}

output "name" {
  value       = local.enabled ? local.name : ""
  description = "Normalized name"
}

output "stage" {
  value       = local.enabled ? local.stage : ""
  description = "Normalized stage"
}

output "delimiter" {
  value       = local.enabled ? local.delimiter : ""
  description = "Delimiter between `namespace`, `resource_type`, `environment`, `stage`, `name` and `attributes`"
}

output "attributes" {
  value       = local.enabled ? local.attributes : []
  description = "List of attributes"
}

locals {
  pitr_capable_default_backup = {
    prod    = "pitr"
    global  = "pitr"
    preprod = "pitr"
    dev     = "weekly"
    sandbox = ""
  }
  other_default_backup = {
    prod    = "daily"
    global  = "daily"
    preprod = "daily"
    dev     = "weekly"
    sandbox = ""
  }
  aws_backup_tags = {
    rds-cluster    = local.pitr_capable_default_backup
    docdb-cluster  = local.pitr_capable_default_backup
    ec2-instance   = local.other_default_backup
    file-system    = local.other_default_backup
    dynamodb-table = local.pitr_capable_default_backup

    #ec-redis      = local.other_default_backup not supported by aws backup

  }
  automatic_aws_backup_tag = lookup(lookup(local.aws_backup_tags, local.resource_type, {}), local.environment, null)
  automatic_tags = local.automatic_aws_backup_tag == null ? {} : {
    aws_backup = local.automatic_aws_backup_tag
  }
}

output "tags" {
  value       = local.enabled ? merge(local.automatic_tags, local.tags) : {}
  description = "Normalized Tag map"
}

output "additional_tag_map" {
  value       = local.additional_tag_map
  description = "The merged additional_tag_map"
}

output "label_order" {
  value       = local.label_order
  description = "The naming order actually used to create the ID"
}

output "regex_replace_chars" {
  value       = local.regex_replace_chars
  description = "The regex_replace_chars actually used to create the ID"
}

output "id_length_limit" {
  value       = local.id_length_limit
  description = "The id_length_limit actually used to create the ID, with `0` meaning unlimited"
}

output "tags_as_list_of_maps" {
  value       = local.tags_as_list_of_maps
  description = <<-EOT
    This is a list with one map for each `tag`. Each map contains the tag `key`,
    `value`, and contents of `var.additional_tag_map`. Used in the rare cases
    where resources need additional configuration information for each tag.
    EOT
}

output "descriptors" {
  value       = local.descriptors
  description = "Map of descriptors as configured by `descriptor_formats`"
}

output "normalized_context" {
  value       = local.output_context
  description = "Normalized context of this module"
}

output "context" {
  value       = local.input
  description = <<-EOT
  Merged but otherwise unmodified input to this module, to be used as context input to other modules.
  Note: this version will have null values as defaults, not the values actually used as defaults.
EOT
}