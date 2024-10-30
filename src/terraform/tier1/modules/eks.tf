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
resource "aws_eks_cluster" "example" {
  name     = "example-eks-cluster"
  version = "1.31" # Specify your desired Kubernetes version

  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = aws_subnet.example[*].id
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"] # Limit this in production
  }

  # Enable control plane logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Create an IAM Role for the EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service":   
 "eks.amazonaws.com"
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
  role       = aws_iam_role.eks_cluster.name  
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16" 
  tags = {
    Name = "example-vpc"
  }
}

# Create Subnets
resource "aws_subnet" "example" {
  count = 2

  vpc_id     = aws_vpc.example.id
  cidr_block = cidrsubnet(aws_vpc.example.cidr_block, 8, count.index)

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "example-subnet-${count.index + 1}"
  }
}

# Get Availability Zones
data "aws_availability_zones" "available" {}