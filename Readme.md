# Parloa Azure Speech module

## Requirements

Login into your Azure account with `az login` and the invoke the commands below. You can then use the default
subscription or you can specify a different one via environment variable `ARM_SUBSCRIPTION_ID`.

You need the following tools:

- terraform https://www.terraform.io/downloads.html
- az https://docs.microsoft.com/en-us/cli/azure/install-azure-cli

## Using this configuration

This configuration can either be used directly or as a module. To use it as a module, add a block like the following to
your root configuration.

```
module "azure_speech" {
  source   = "path/to/module"
  location = "westeurope"
}
```

For a high availability setup, you may choose to add multiple `module` blocks like this one. Choose different locations
for each block to ensure resiliency to Azure location incidents.

## Note on remote state

It is strongly recommended to use [Terraform remote state](https://www.terraform.io/docs/language/state/remote.html)
when using this configuration for non-testing purposes.

This may not be necessary if you are using this configuration as a module and the root configuration already has a
remote state configuration.

Example remote state configuration using the
[azurerm Terraform backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html).

```
terraform {
  backend "azurerm" {
    resource_group_name   = "your-resource-group"
    storage_account_name  = "your-storage-account"
    container_name        = "your-storage-container"
    key                   = "terraform.tfstate"
  }
}
```

## Create the infrastructure

```sh
# Can be used to define the subscription id.
# ARM_SUBSCRIPTION_ID

terraform init
TF_WORKSPACE=your-workspace terraform apply
```
