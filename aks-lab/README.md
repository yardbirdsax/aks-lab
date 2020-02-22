# Creating an AKS Lab

This set of steps will create a very basic AKS cluster with no RBAC enabled, basic networking, and no interconnection with existing resources. In other words, definitely not something to do in any kind of live environment, but fine for a first foray.

## Pre-Requisites

1. You must create a storage account and container to store Terraform state information.

    ```bash
    az storage account create -n jeftfstate -g jeftfstate --location eastus2 --kind StorageV2
    ```

    >**TIP**: Do not create the storage account in the same resource group where the AKS cluster will be, so it can't easily be accidentally deleted when cleaning up your lab.

1. You must create a storage container in the storage account.

    ```bash
    az storage container create --name tfstate --account-name jeftfstate
    ```

1. You must initialize the back-end using the storage account and container you just created.

    ```bash
    [josh@Joshua-PC terraform ]$ terraform init \
    > -backend-config "storage_account_name=jeftfstate" \
    > -backend-config "container_name=tfstate" \
    > -backend-config "key=test.tfstate" \
    > -backend-config "resource_group_name=jeftfstate"
    ```

    >**TIP**: For each lab you create, make sure you change the value of the "key" in the command above.

1. You must create an Azure Key Vault to store the values of the Service Principal password.

    ```bash
    az keyvault create -n jeftfkeyvault -g jeftfstate
    ```

1. You must create a Secret in the key vault to store the actual password.

    ```bash
    az keyvault secret set --vault-name jeftfkeyvault --name 'jefaks01-sp' --value 'A crazy password here'
    ```

    >**IMPORTANT**: The secret name should be the name of the AKS cluster with "-sp" appended to the end.

## Creating the AKS cluster

1. Make a copy of the "sample.tfvars" file and edit the values as necessary.
1. Run Terraform to create the AKS cluster.

    ```bash
    terraform apply -var-file "path/to/varfile.tfvars"
    ```

## Destroying the lab

To remove all created resources, all you need to do is run the `terraform destroy` command.

```bash
