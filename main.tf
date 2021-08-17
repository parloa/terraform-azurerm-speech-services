terraform {
}

provider "azurerm" {
  features {}
  partner_id = "f271300d-514c-48bf-b030-80443ba68110"
}

resource "azurerm_resource_group" "parloa_speech" {
  name     = "${terraform.workspace}-speech-${var.location}"
  location = var.location
}

resource "azurerm_cognitive_account" "azure_speech" {
  name                = "${terraform.workspace}-speech-${var.location}"
  location            = azurerm_resource_group.parloa_speech.location
  resource_group_name = azurerm_resource_group.parloa_speech.name
  kind                = "SpeechServices"
  sku_name            = "S0"
}
