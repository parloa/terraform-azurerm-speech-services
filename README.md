# Parloa Azure Speech module

This terraform module creates Azure SpeechServices Resources for Parloa.

## Requirements

Login into your Azure account with `az login` and the invoke the commands below. You can then use the default
subscription or you can specify a different one via environment variable `ARM_SUBSCRIPTION_ID`.

You need the following tools:

- [terraform](https://www.terraform.io/downloads.html)
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

| Name      | Version   |
| --------- | --------- |
| terraform | >= 0.13.1 |
| azurerm   | >= 2.62.1 |

## Module usage

This module can be used by adding a block like the following to your root configuration.

```hcl
module "azure_speech" {
  source   = "github.com/parloa/terraform-azurerm-speech-services"
  location = "westeurope"
}
```

For a high availability setup, you may choose to add multiple `module` blocks like this one. Choose different locations for each block to ensure resiliency to Azure location incidents. See [here](./example/multiple-regions) for an example.

## Inputs

| Name       | Description                                                          | Type   | Default    |
| ---------- | -------------------------------------------------------------------- | ------ | ---------- |
| `location` | The azure region in which the Azure Speech service should be created | string | westeurope |

## Outputs 

| Name            | Description                                                    |
| --------------- | -------------------------------------------------------------- |
| `location`      | The azure region in which the Azure Speech service was created |
| `key`           | The speech serice accounts's primary access key                |
| `key_secondary` | The speech serice accounts's secondary access key              |

### Note on remote state

It is strongly recommended to use [Terraform remote state](https://www.terraform.io/docs/language/state/remote.html)
when using this configuration for non-testing purposes.

This may not be necessary if you are using this configuration as a module and the root configuration already has a
remote state configuration.

Example remote state configuration using the
[azurerm Terraform backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html).

```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "your-resource-group"
    storage_account_name  = "your-storage-account"
    container_name        = "your-storage-container"
    key                   = "terraform.tfstate"
  }
}
```

## Create Azure SpeechService resource

This guide explains how to create an azure-speech secret for your k8s cluster
by leveraging this terraform module.

This gude assumes you the commands below on your system: 

- [jq](https://stedolan.github.io/jq/)
- [yq>=4](https://mikefarah.gitbook.io/yq/#install)  

Move into the directory example/multiple-regions.

```sh
cd examples/multiple-regions
```

Now we create the application.yaml which will contain the azure speech service subscriptions.  
Before you continue you can modify `main.tf` to your needs by altering the region or adding more
regions.

NOTE: The name of the workspace name will be the prefix of the creeated 
resource group name.

```sh
export TF_WORKSPACE=parloa
# or 
terraform workspace new parloa .

terraform init
terraform plan
terraform apply 

terraform output -json | \
    jq -r '
    to_entries  
    | map_values({region: .value.value.location, subscriptionKey: .value.value.key}) 
    | {azure: {subscriptions: .}}' | \
    yq -P e . - > application.yaml
```

The order of the created subscriptions elements matters, as the phone-gateway will use them in the specified order, so you have now the opportunity to change this to your needs.

You can create the k8s secret by invoking: 

```sh
kubectl create secret generic azure-speech --from-file application.yaml

```
