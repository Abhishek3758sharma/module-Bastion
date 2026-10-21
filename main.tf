data "azurerm_subnet" "subnets" {
  for_each = var.bastiond

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_public_ip" "pips" {
  for_each            = var.bastiond

  name                = each.value.public_ip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_bastion_host" "main" {
  for_each = var.bastiond
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = "Standard"

  ip_configuration {
    name                 = each.value.ip_name
    subnet_id            = data.azurerm_subnet.subnets[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pips[each.key].id

  }
}