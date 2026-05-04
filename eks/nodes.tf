resource "aws_iam_role" "nodes" {
  name = "${local.env}-${local.eks_name}-eks-nodes"

  assume_role_policy = <<POLICY
   {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       }
     }
   ]
   }
   POLICY
}