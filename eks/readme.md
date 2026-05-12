Steps:
1) Create locals.tf
2) Create Provider.tf
3) Create vpc.tf
4) Create Internet gateway and attach VPC
5) Create 2 private, 2 public subnets
6) create nat gateway: Used to translate private IP addresses to public ones
7) 

Pre-requisites:

Kubectl Installed:

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

Verify
kubectl version --client


IAM:

EKS requires some permissions to access AWS Services. For that we 
create IAM role and define the trust policy. This is done with principal
property in IAM role. In this case we create IAM role to be used by EKS and nothing else.
 
2) Create EKS Cluster:

There must be atleast 2 private subnets as Amazon will create cross-account elastic network
interfaces in these subnets to allow communication between your worker nodes and kubernetes control plane.
  aws_subnet.private_zone1.id,
  aws_subnet.private_zone2.id


 access_config {
      authentication_mode = "API" # Kubernetes API that you use to add users to your cluster
      bootstrap_cluster_creator_admin_permissions = true
    }

access_config defines how users/roles are allowed to authenticate and get RBAC permissions in your EKS cluster.
CONFIG_MAP → old way (aws-auth ConfigMap in Kubernetes)
API → new recommended way

 bootstrap_cluster_creator_admin_permissions = true
 It gives the IAM identity that creates the EKS cluster:
 The creator IAM user/role gets:
Full Kubernetes admin (system:masters)
No need to manually grant access initially

3) Create node group:

files: nodes.tf
 EKS generally has 2 types of groups.
Self managed node group you create using terraform and templates manually. It is useful when you have specific requirements for the nodes 

EKS Managed node groups
Its easier to manage and do upgrades

Fargate:
Serverless service.When you create a pod, EKS will create a dedicated node for each pod. Its way easier but more expensive 

The autoscaling settings are defined in terraform and the desired size property is updated by the autoscaler. Autoscaling can be done by Karpenter/KEDA

4) Connect to the cluster

Check user that is connected:
1) ajayp@Ajay:~/workspace/githubrepos/terraform/eks$ aws sts get-caller-identity
{
    "UserId": "AIDAQ3EGRLYBM7ZHCCVC4",
    "Account": "058264215042",
    "Arn": "arn:aws:iam::058264215042:user/ajaypillagolla"
}

2)Update kube-config 
 ajayp@Ajay:~/workspace/githubrepos/terraform/eks$ aws eks update-kubeconfig --region us-east-2 --name staging-demo
Added new context arn:aws:eks:us-east-2:058264215042:cluster/staging-demo to /home/ajayp/.kube/config

3) Validate if nodes are reachable

ajayp@Ajay:~/workspace/githubrepos/terraform/eks$ kubectl get nodes
NAME                                        STATUS   ROLES    AGE   VERSION
ip-10-0-31-238.us-east-2.compute.internal   Ready    <none>   15m   v1.35.4-eks-4136f65

3) Command to check read/write access to all.
ajayp@Ajay:~/workspace/githubrepos/terraform/eks$ kubectl auth can-i "*" "*"
yes






