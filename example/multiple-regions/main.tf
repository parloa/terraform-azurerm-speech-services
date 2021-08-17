
module "azure_speech_westeurope" {
  source   = "github.com/parloa/terraform-azurerm-speech-services"
  location = "westeurope"
}

module "azure_speech_francecentral" {
  source   = "github.com/parloa/terraform-azurerm-speech-services"
  location = "francecentral"
}

