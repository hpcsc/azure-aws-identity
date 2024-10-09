locals {
  name = "azure-aws-identity"
}

module "azure" {
  source = "./azure"

  name = local.name
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
