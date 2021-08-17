
module "azure_speech_westeurope" {
  source   = "parloa/speech-services/azurerm"
  version  = "1.0.0"
  location = "westeurope"
}

module "azure_speech_francecentral" {
  source   = "parloa/speech-services/azurerm"
  version  = "1.0.0"
  location = "francecentral"
}

