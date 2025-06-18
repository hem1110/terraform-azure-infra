
resource "azurerm_key_vault" "main" {
  name                          = "kv-hemanth"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    virtual_network_subnet_ids = [
      azurerm_subnet.subnet_keyvault.id
    ]
  }
}

resource "azurerm_private_endpoint" "keyvault_pe" {
  name                = "keyvault-pe-hemanth"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.subnet_keyvault.id

  private_service_connection {
    name                           = "keyvault-pe-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}
