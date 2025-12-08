# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# variable "regions" {
#   type = set(string)
# }

variable "region" {
  type        = string
  description = "AWS region to deploy TFE"
}

variable "friendly_name_prefix" {
  description = "Friendly name prefix"
  type        = string
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "role_arn" {
  type = string
}

variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

variable "tfe_fqdn" {
  description = "Full DNS name for the TFE application"
  type        = string
}

variable "upstream_networks" {
  description = "Networks created by prereqs module"
  type = object({
    vpc_id                = string
    compute_subnet_ids    = optional(list(string))
    lb_subnet_ids_public  = optional(list(string))
    lb_subnet_ids_private = optional(list(string))
  })
}

variable "upstream_secrets" {
  description = "Secrets created by prereqs module"
  type = object({
    tfe_license_secret_arn             = optional(string)
    tfe_encryption_password_secret_arn = optional(string)
    tfe_database_password_secret_arn   = optional(string)
    tfe_redis_password_secret_arn      = optional(string)
  })
}

variable "upstream_pki" {
  description = "TLS keys and certs created by prereqs module"
  type = object({
    tfe_tls_privkey_secret_arn   = optional(string)
    tfe_tls_cert_secret_arn      = optional(string)
    tfe_tls_ca_bundle_secret_arn = optional(string)
  })
}
