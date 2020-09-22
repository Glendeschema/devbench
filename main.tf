
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_state"
    storage_account_name = "schematerraformstate"
    container_name       = "state"
    key                  = "terraform.tfstate"

  }
}



resource "azurerm_virtual_network" "vnet" {
  name                = "scaleset-vnet"
  resource_group_name = azurerm_resource_group.importrg.name
  location            = azurerm_resource_group.importrg.location
  address_space       = ["10.0.0.0/16"]
  depends_on          = [azurerm_resource_group.importrg]
}

resource "azurerm_subnet" "front-end" {

  name                 = "front-end"
  resource_group_name  = azurerm_resource_group.importrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  location            = azurerm_resource_group.importrg.location
  resource_group_name = azurerm_resource_group.importrg.name
  allocation_method   = "Static"
  domain_name_label   = "schematerraform"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_lb" "lb" {
  name                = "loadbalancer"
  location            = azurerm_resource_group.importrg.location
  resource_group_name = azurerm_resource_group.importrg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.importrg.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.importrg.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_nat_pool" "lbnatpool1" {
  resource_group_name            = azurerm_resource_group.importrg.name
  name                           = "https"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 60000
  frontend_port_end              = 60090
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}



resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "frontend-vmss"
  resource_group_name             = azurerm_resource_group.importrg.name
  location                        = azurerm_resource_group.importrg.location
  sku                             = "Standard_F2"
  instances                       = 1
  admin_username                  = "adminuser"
  disable_password_authentication = false

  extension {
    name                 = "install-nginx"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
 
    settings = <<SETTINGS
    {
    "fileUris": ["https://schematerraformstate.blob.core.windows.net/code/apache2.sh"],
    "commandToExecute": "bash apache2.sh"
    }
SETTINGS
  }
  admin_password = "Munch13w@k@@2020"

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.front-end.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id ,azurerm_lb_nat_pool.lbnatpool1.id]
    }

  }
}





