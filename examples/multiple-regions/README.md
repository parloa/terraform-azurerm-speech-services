# Multiple speech service accounts in different regions

This example demonstrates how you can create multiple speech service accounts
in different regions. In this case we create a account for the region `westeurope` and 
`francecentral`.

## Requirements

- [jq](https://stedolan.github.io/jq/)
- [yq>=4](https://mikefarah.gitbook.io/yq/#install) 
- [terraform](https://www.terraform.io/downloads.html)
- [az](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

## Terraform Usage

To run this example you need to execute following commands

```sh
terraform workspace new example-multiple-regions .
terraform init
terraform plan
terraform apply

# You can use jq and yq4 to generate the azure speech secret file.
terraform output -json | \
    jq -r '
    to_entries  
    | map_values({region: .value.value.location, subscriptionKey: .value.value.key}) 
    | {azure: {subscriptions: .}}' | \
    yq -P e . - > application.yaml
kubectl create secret generic azure-speech --from-file application.yaml  

# Or you can build this secret manually by tacking the key and location from
terraform output -json

```

Run `terraform destroy` when you don't need these resources.