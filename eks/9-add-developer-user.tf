resource "aws_iam_user" "developer" {
  name = "developer"

}

# grant access to eks in AWS to be able to update local kubernetes config and connect to the cluster

resource "aws_iam_policy" "developer_eks" {
  name = "AmazonEKSDeveloperPolicy"

  policy = <<POLICY
  {
     "Version": "2012-10-17",
     "Statement": [
     {
        "Effect": "Allow",
        "Action": [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        "Resource": "*"
     }
     
      ]
  }
  POLICY
}

#Attach Policy - Best Practice is to attach permissions to an IAM group and add user to the group

resource "aws_iam_user_policy_attachment" "developer_eks" {
user = aws_iam_user.developer.name
policy_arn = aws_iam_policy.developer_eks.arn

}

# Bind developer IAM user with RBAC my-viewer group using EKS API.
# This part is managed using Kubernetes auth config map but it is deprecated. This is the recommended option.
resource "aws_eks_access_entry" "developer" {
  cluster_name = aws_eks_cluster.eks.name
  principal_arn = aws_iam_user.developer.arn
  kubernetes_groups = ["my-viewer"]
}