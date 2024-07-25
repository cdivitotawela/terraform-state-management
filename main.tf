resource "azurerm_resource_group" "demo" {
  name     = "demo"
  location = "australiaeast"
}

module "storage_accounts" {
  source = "./modules/demo-storage-account"

  resource_group_name = azurerm_resource_group.demo.name
  location = azurerm_resource_group.demo.location
}