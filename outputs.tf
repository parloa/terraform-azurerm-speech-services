output "location" {
  sensitive = true
  value = var.location
}

output "key" {
  sensitive = true
  value = azurerm_cognitive_account.azure_speech.primary_access_key
}

output "key_secondary" {
  sensitive = true
  value = azurerm_cognitive_account.azure_speech.secondary_access_key
}
