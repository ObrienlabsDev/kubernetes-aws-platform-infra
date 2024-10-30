# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create an EKS Cluster

resource "aws_eks_cluster" "eks_cluster" {
  name     = "example-eks-cluster"
  version = "1.30" # Specify your desired Kubernetes version

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    #subnet_ids              = aws_subnet.eks-private-sn[*].id
    subnet_ids = [
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id,
    ]
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"] # Limit this in production
  }

  tags = {
    Name = "eks-cluster"
  }

  # Enable control plane logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Create an IAM Role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach the AmazonEKSClusterPolicy to the IAM Role
resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name  
}

# Attach the AmazonEKSWorkerNodePolicy to the role
resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_cluster_role.name 
}

# Attach the AmazonEC2ContainerRegistryReadOnly to the role
resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role.name 
}

# Create a VPC
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "eks-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Replace with your AZ

  tags = {
    Name = "eks-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Replace with your AZ

  tags = {
    Name = "eks-private-subnet-2"
  }
}
/*resource "aws_subnet" "eks-private-sn" {
  count = 2

  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "eks-private-subnet-${count.index + 1}"
  }
}*/

# Create a node group (optional)
/*resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_cluster_role.arn # Replace with your node role ARN
  subnet_ids      = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  scaling_config {
    desired_size = 2
    max_size = 3
    min_size = 1
  }

  instance_types = ["t3.medium"]

  tags = {
    Name = "my-node-group"
  }
}*/

# Get Availability Zones
data "aws_availability_zones" "available" {}