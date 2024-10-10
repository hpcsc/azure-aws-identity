locals {
  name = "azure-aws-identity"
}

module "azure" {
  source = "./azure"

  name = local.name
}

module "aws" {
  source = "./aws"

  name               = local.name
  azure_tenant_id    = module.azure.tenant_id
  azure_sp_object_id = module.azure.sp_object_id
}

output "azure_tenant_id" {
  value = module.azure.tenant_id
}

output "azure_application_client_id" {
  value = module.azure.application_client_id
}

output "azure_sp_object_id" {
  value = module.azure.sp_object_id
}

output "azure_application_password" {
  sensitive = true
  value     = module.azure.application_password
}

output "aws_oidc_arn" {
  value = module.aws.oidc_arn
}

output "aws_iam_role_arn" {
  value = module.aws.iam_role_arn
}
