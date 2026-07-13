# Steps for AKS  

## 1.Use Service Principle for terraform to authenticate to Azure resources
1) Create Service principle:
 az ad sp create-for-rbac -n az-demo --role="Contributor" --scopes="/subscriptions/dfd59b85-4966-43d0-b74f-5c5e30954da9"
2) View Service prinicipal
az ad sp list --output table
az ad sp list --display-name az-demo
az ad sp list --display-name az-demo --output table
az ad sp list --query "[].displayName" --output table
## Output
{
  "appId": "replace",
  "displayName": "replace",
  "password": "replace",
  "tenant": "replace"
}

export ARM_CLIENT_ID="replace"
export ARM_CLIENT_SECRET="replace"
export ARM_SUBSCRIPTION_ID="replace"
export ARM_TENANT_ID="replace"

4) login using service principal:
az login --service-principal \
  --username "$ARM_CLIENT_ID" \
  --password "$ARM_CLIENT_SECRET" \
  --tenant "$ARM_TENANT_ID"

## 2. Create backend for terraform

https://github.com/AjayPillagolla/terraform/tree/main/azure/Lesson2/azuretfbackend

## 3. Create aks cluster
