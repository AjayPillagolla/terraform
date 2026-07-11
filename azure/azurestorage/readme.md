# Create Azure Storage account
Youtube: https://www.youtube.com/watch?v=RdqiDN4V5Cg&list=PLl4APkPHzsUUHlbhuq9V02n9AMLPySoEQ&index=4

# Use Service Principle for terraform to authenticate to Azure resources
1) Create Service principle:
 az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/replace"
2) View Service prinicipal
az ad sp list --output table
az ad sp list --display-name az-demo
az ad sp list --display-name az-demo --output table
az ad sp list --query "[].displayName" --output table
## Output

export ARM_CLIENT_ID="replace"
export ARM_CLIENT_SECRET="replace"
export ARM_SUBSCRIPTION_ID="replace"
export ARM_TENANT_ID="replace"

4) login using service principal:
az login --service-principal \
  --username "$ARM_CLIENT_ID" \
  --password "$ARM_CLIENT_SECRET" \
  --tenant "$ARM_TENANT_ID"



ajayp@Ajay:~/workspace/githubrepos/terraform/azure/azurestorage$ alias tf=terraform

# Remote state Backend

## Architecture

```mermaid
graph TD

Dev[Developer / CI Pipeline] --> TF[Terraform CLI / IaC Tool]

TF --> BackendConfig[Remote Backend Config]

BackendConfig --> AzureRM[Azure Subscription]

AzureRM --> RG[Resource Group]

RG --> SA[Storage Account]

SA --> Container[Blob Container (tfstate)]

Container --> StateFile[terraform.tfstate]

TF --> Lock[State Locking]

Lock --> Lease[Blob Lease Lock in Azure Storage]

TF --> Plan[terraform plan]
TF --> Apply[terraform apply]

Plan --> BackendRead[Read State from Azure Blob]
Apply --> BackendWrite[Write State to Azure Blob]

BackendRead --> Container
BackendWrite --> Container

subgraph Azure Remote Backend
    SA
    Container
    StateFile
    Lease
end
````