provider azurerm {

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id



  features {}

}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}


variable "prefix" {
  description = "The prefix which should be used for all resources in this example"

}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."

}

