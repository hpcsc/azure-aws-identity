output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}

output "application_client_id" {
  value = azuread_application.main.client_id
}

output "application_password" {
  sensitive = true
  value     = tolist(azuread_application.main.password).0.value
}

output "sp_object_id" {
  value = azuread_service_principal.main.object_id
}
