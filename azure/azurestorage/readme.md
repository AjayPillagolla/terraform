# Create Azure Storage account
Youtube: https://www.youtube.com/watch?v=RdqiDN4V5Cg&list=PLl4APkPHzsUUHlbhuq9V02n9AMLPySoEQ&index=4

1.Create Service Principal

ajayp@Ajay:~/workspace/githubrepos/terraform/azure$ az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/cb1acf17-97e2-4a81-8019-d927d17f646b"
Found an existing application instance: (id) 04dec63f-21e7-4bf3-ba78-7984367f74f6. We will patch it.
Creating 'Contributor' role assignment under scope '/subscriptions/cb1acf17-97e2-4a81-8019-d927d17f646b'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "99e3e2fd-2061-493a-a8cf-71512004277e",
  "displayName": "az-demo",
  "password": "tHs8Q~Oxnq6D2wRi8k5W~ow4U48x5Sm0cxbfib42",
  "tenant": "a8797389-ef48-4216-a392-06fceb38312f"
}

export ARM_CLIENT_ID="99e3e2fd-2061-493a-a8cf-71512004277e"
export ARM_CLIENT_SECRET="tHs8Q~Oxnq6D2wRi8k5W~ow4U48x5Sm0cxbfib42"
export ARM_SUBSCRIPTION_ID="cb1acf17-97e2-4a81-8019-d927d17f646b"
export ARM_TENANT_ID="a8797389-ef48-4216-a392-06fceb38312f"

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