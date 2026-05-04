resource "aws_iam_role" "eks" {
    name = "${local.env}-${local.eks_name}-eks-cluster"
    assume_role_policy = <<POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "eks.amazonaws.com"
          }
        }
      ] 
       
    }
    POLICY    
}

# Attach EKS policy to the role

resource "aws_iam_role_policy_attachment" "eks" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role = aws_eip.eks.name
}

resource "aws_eks_cluster" "eks" {
    name = "${local.env}-${local.eks_name}"
    version = local.eks_version
    role_arn = aws_iam_role.eks.arn

    vpc_config {
      endpoint_private_access = false
      endpoint_public_access = true

      subnet_ids = [
        aws_subnet.private_zone1.id,
        aws_subnet.private_zone2.id
      ]
    }

    access_config {
      authentication_mode = "API" # Kubernetes API that you use to add users to your cluster
      bootstrap_cluster_creator_admin_permissions = true
    }

    depends_on = [ aws_iam_role_policy_attachment.eks ]
}