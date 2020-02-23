terraform {
    backend "azurerm" {}
}

provider "azurerm" {
  version = "=1.33.1"
}

provider "azuread" {
    version = ">=0.3.1"
}

resource "azuread_application" "aksApp" {
    name = "${var.clusterName}"
}

resource "azuread_service_principal" "aksSp" {
    application_id = "${azuread_application.aksApp.application_id}"
}

data "azurerm_key_vault" "aksKeyVault" {
    name = "${var.vaultName}"
    resource_group_name = "${var.vaultResourceGroupName}"
}

data "azurerm_key_vault_secret" "aksSpSecret" {
    name = "${var.clusterName}-sp"
    key_vault_id = "${data.azurerm_key_vault.aksKeyVault.id}"
}

resource "azuread_service_principal_password" "aksSpPassword" {
    service_principal_id = "${azuread_service_principal.aksSp.id}"  
    value = "${data.azurerm_key_vault_secret.aksSpSecret.value}"
    # 100 years
    end_date_relative = "876000h"
}

resource "azurerm_resource_group" "clusterResourceGroup" {
  name = "${var.clusterResourceGroupName}"
  location = var.location
}


resource "azurerm_kubernetes_cluster" "aksCluster" {
    name = "${var.clusterName}"  
    resource_group_name = "${azurerm_resource_group.clusterResourceGroup.name}"
    location = "${azurerm_resource_group.clusterResourceGroup.location}"
    dns_prefix = "${var.clusterName}"
    
    agent_pool_profile {
        name = "default"
        count = 1
        vm_size = "${var.vmSize}"
        os_type = "Linux"
    }

    service_principal {
        client_id = "${azuread_application.aksApp.application_id}"
        client_secret = "${data.azurerm_key_vault_secret.aksSpSecret.value}"
    }

    depends_on = [
        azuread_service_principal_password.aksSpPassword
    ]
}

# resource local_file kubeconfig {
#     filename = "~/.kube/${azurerm_kubernetes_cluster.aksCluster.name}"
#     content = azurerm_kubernetes_cluster.aksCluster.kube_config_raw
# }

