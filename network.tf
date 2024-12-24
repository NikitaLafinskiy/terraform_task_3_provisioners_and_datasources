resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = data.azurerm_resource_group.resourcegroup.name
  location            = data.azurerm_resource_group.resourcegroup.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = data.azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}