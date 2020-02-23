variable "clusterName" {
  type = string
  description = "The name of the AKS cluster to be created."
}

variable "clusterResourceGroupName" {
  type = string
  description = "The name of the resource group where the cluster resides."
}

variable "vaultName" {
  type = string
  description = "The name of the Azure Keyvault that has the secret holding the Service Principal password."
}

variable "vaultResourceGroupName" {
  type = string
  description = "The name of the resource group where the key vault resides."
}

variable "vmSize" {
  type = string
  description = "The size of the worker node VMs."
  default = "Standard_B2ms"
}

variable "location" {
  type = string
  description = "The Azure region where the resources will be deployed."
  default = "eastus2"
}


