resource "random_string" "random" {
  length           = 17
  special          = false
  upper            = false
}

resource "azurerm_storage_account" "demo" {
  for_each = toset(["one","two"])
  name                     = "${random_string.random.result}${each.key}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "demo"
  }
}