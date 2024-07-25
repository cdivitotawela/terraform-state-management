# Terraform State Management

This contains deleting and importing Terraform resources from state for modules. 
Example here shows how to delete and import resources to Terraform state.

## Setup

Lets provision the resources for this exercise

```bash
az login
az account set --name <subscription name>

# Provision infrastructure
terraform init
terraform plan -o plan.tfplan
terraform apply plan.tfplan
```

## Remove Resource from State

```bash
# List the terraform resource in the state
terraform state list
```

output
```
azurerm_resource_group.demo
module.storage_accounts.azurerm_storage_account.demo["one"]
module.storage_accounts.azurerm_storage_account.demo["two"]
module.storage_accounts.random_string.random
```

Remove resources from state
```bash
# Quotes are very important
terraform state rm 'module.storage_accounts.azurerm_storage_account.demo["one"]'

# Can use double quotes as follows
terraform state rm "module.storage_accounts.azurerm_storage_account.demo[\"two\"]"
```

## Import resources to state
Import removed storage accounts back

```bash
# Quotes are very important
terraform import 'module.storage_accounts.azurerm_storage_account.demo["one"]' /subscriptions/<subscription id>/resourceGroups/demo/providers/Microsoft.Storage/storageAccounts/<storage account name>

# Can use double quotes as follows
terraform import 'module.storage_accounts.azurerm_storage_account.demo["two"]' /subscriptions/<subscription id>/resourceGroups/demo/providers/Microsoft.Storage/storageAccounts/<storage account name>
```


## Testing Terraform State Operations Locally

If the state is in remote backend and making any changes could be risky. We can export the state to local file and do all
the testing before making changes to remote state.

```bash
# Pull remote state to local file
terraform state pull > terraform.tfstate.remote

# Change the provider configuration by removing the backend
# Update the file manually

# Initialise again. Do not migrate the state
# This will create terraform.tf.state file
terraform init -reconfigure

# Replace the local state file with exported file
cp terraform.tfstate.remote terraform.tfstate

# Run the terraform plan and check the state
# There shouldn't be any changes as local state file should match the infrastructure
terraform plan

# Now you can delete/import to the state file for testing
```
