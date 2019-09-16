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

