# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

component "a" {
  for_each = var.regions

  source = "./local-module"
  # source = "git::https://github.com/hashicorp-services/terraform-aws-tfe-prereqs.git"
  # source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v19.21.0"

  inputs = {
    region = each.value
  }

  providers = {
    aws    = provider.aws.configurations[each.value]
    random = provider.random.this
  }
}

# component "b" {
#   for_each = var.regions

#   source = ""

#   inputs = {
#     region    = var.regions
#     bucket_id = component.a[each.value].bucket_id
#   }

#   providers = {
#     aws     = provider.aws.configurations[each.value]
#     archive = provider.archive.this
#     local   = provider.local.this
#     random  = provider.random.this
#   }
# }

# component "c" {
#   for_each = var.regions

#   source = ""

#   inputs = {
#     region               = each.value
#     lambda_function_name = component.lambda[each.value].function_name
#     lambda_invoke_arn    = component.lambda[each.value].invoke_arn
#   }

#   providers = {
#     aws    = provider.aws.configurations[each.value]
#     random = provider.random.this
#   }
# }
