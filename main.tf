
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_state"
    storage_account_name = "schematerraformstate"
    container_name       = "state"
    key                  = "terraform.tfstate"

  }
}
resource azurerm_resource_group "rg2" {

  location = "southafricanorth"
  name     = "testRG"
}

resource azurerm_automation_account "aa" {
  name                = "automation"
  resource_group_name = azurerm_resource_group.rg2.name
  location            = azurerm_resource_group.rg2.location
  sku_name            = "Free"

  tags = {

    env = "dev"
  }


}

