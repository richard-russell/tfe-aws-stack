# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

locals {
  fqdn_parts = split(".", var.tfe_fqdn)
  zone_name = join(".", slice(local.fqdn_parts, 1, length(local.fqdn_parts)))
}

component "tfe" {

  source  = "app.terraform.io/richard-russell-org/terraform-enterprise-hvd/aws"
  version = "0.0.1"

  inputs = {
    friendly_name_prefix = var.friendly_name_prefix
    common_tags          = var.default_tags
    tfe_operational_mode = "active-active"

    # --- Networking --- #
    tfe_fqdn       = var.tfe_fqdn
    vpc_id         = var.upstream_networks.vpc_id
    lb_is_internal = false
    ec2_subnet_ids = var.upstream_networks.compute_subnet_ids
    lb_subnet_ids  = var.upstream_networks.lb_subnet_ids_public
    rds_subnet_ids = var.upstream_networks.compute_subnet_ids
    redis_subnet_ids = var.upstream_networks.compute_subnet_ids

    # --- Secrets Manager "Bootstrap" Secrets --- #
    tfe_database_password_secret_arn   = var.upstream_secrets.tfe_database_password_secret_arn
    tfe_encryption_password_secret_arn = var.upstream_secrets.tfe_encryption_password_secret_arn
    tfe_license_secret_arn             = var.upstream_secrets.tfe_license_secret_arn
    tfe_tls_ca_bundle_secret_arn       = var.upstream_pki.tfe_tls_ca_bundle_secret_arn
    tfe_tls_cert_secret_arn            = var.upstream_pki.tfe_tls_cert_secret_arn
    tfe_tls_privkey_secret_arn         = var.upstream_pki.tfe_tls_privkey_secret_arn

    # --- DNS (optional) --- #
    create_route53_tfe_dns_record      = true
    route53_tfe_hosted_zone_name       = local.zone_name
    route53_tfe_hosted_zone_is_private = false

    # --- Compute --- #
    ec2_instance_size          = "t3.large"
    cidr_allow_ingress_ec2_ssh = ["10.0.0.0/16"]
    ec2_ssh_key_pair           = "KeyVanCleef"

    # --- Database --- #
    rds_skip_final_snapshot   = true
    rds_aurora_instance_class = "db.r5.large"
    rds_aurora_replica_count  = 0
  }

output "tfe_url" {
  value       = component.tfe.tfe_url
  type        = string
  description = "URL to access TFE application based on value of `tfe_fqdn` input."
}

output "tfe_create_initial_admin_user_url" {
  value       = component.tfe.tfe_create_initial_admin_user_url
  type        = string
  description = "URL to create TFE initial admin user."
}

  providers = {
    aws = provider.aws.this
    # aws     = provider.aws.configurations[each.value]
    # archive = provider.archive.this
    # local   = provider.local.this
    # random  = provider.random.this
  }
}

