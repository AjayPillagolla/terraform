Steps:
1) Create locals.tf
2) Create Provider.tf
3) Create vpc.tf
4) Create Internet gateway and attach VPC
5) Create 2 private, 2 public subnets
6) create nat gateway: Used to translate private IP addresses to public ones
7) 

Pre-requisites:

IAM:

EKS requires some permissions to access AWS Services. For that we 
create IAM role and define the trust policy. This is done with principal
property in IAM role. In this case we create IAM role to be used by EKS and nothing else.
 
EKS Cluster:
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