# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

upstream_input "aws-tfe-prereqs" {
  type   = "stack"
  source = "app.terraform.io/richard-russell-org/TFE/tfe-aws-prereqs-stack"
}


deployment "development" {
  inputs = {
    role_arn       = "arn:aws:iam::363715248670:role/tfc-workload-identity-richard-russell-org"
    identity_token = identity_token.aws.jwt
    default_tags   = { stacks-preview-example = "lambda-component-expansion-stack" }

    tfe_fqdn          = "tfe-mushypea.richard-russell.sbx.hashidemos.io"
    upstream_networks = upstream_input.aws-tfe-prereqs.outputs.development_networks
    upstream_secrets  = upstream_input.aws-tfe-prereqs.outputs.development_secrets
    upstream_pki      = upstream_input.aws-tfe-prereqs.outputs.development_pki
  }
}

