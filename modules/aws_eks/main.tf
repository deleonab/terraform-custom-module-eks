resource "aws_eks_cluster" "acme_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.acme_eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.ACME-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ACME-AmazonEC2ContainerRegistryReadOnly,

  ]
  tags = var.tags
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "acme_eks_cluster" {
  name               = "acme-eks-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ACME-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.acme_eks_cluster.name
}


resource "aws_iam_role_policy_attachment" "ACME-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.acme_eks_cluster.name
}

