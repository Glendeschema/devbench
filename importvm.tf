resource azurerm_resource_group "importrg" {
  location = "northeurope"
  name     = "front-end_group"
}

output "rgname" {
  value = azurerm_resource_group.importrg.name

}

output "rglocation" {

  value = azurerm_resource_group.importrg.location

}