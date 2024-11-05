# kubernetes-aws-platform-infra
An AWS based kubernetes platform infrastructure project

# Architecture
## Tiers
We will deploy a logicical and virtual set of tiers.
Logically we have platform infrastructure consisting of shared network (VPC,,,), shared services (cluster provisioning, CICD..).
Virtually we have platform insrastucture that is required to deploy - base management network, base management kubernetes cluster, base management shared services.

### Tier 0 - development environment

## Tools
- AWS
  - awscli
  - DynamoDB
  - EKS
  - Elasticache
- brew
- Falco (Kernel Security)
- Go
- jq
- Kubernetes
  - ArgoCD
  - Cluster API (CAPI)
  - helm v3
  - kubernetes-cli (kubectl)
  - Kustomize (separate or as part of kubectl)
  - 
- Make
- Python
- Robot
- tfenv

## Features
## Enhancement Requests
- public IP addressing

# References
- https://github.com/ObrienlabsDev/blog/wiki/Architecture

# Deployment logs
```
aws_iam_role.eks_cluster_role: Creating...
aws_vpc.eks_vpc: Creating...
aws_iam_role.eks_cluster_role: Creation complete after 0s [id=eks-cluster-role]
aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy: Creating...
aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy: Creating...
aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly: Creating...
aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy: Creation complete after 1s [id=eks-cluster-role-20241105165656527700000001]
aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly: Creation complete after 1s [id=eks-cluster-role-20241105165656635200000002]
aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy: Creation complete after 1s [id=eks-cluster-role-20241105165656647100000003]
aws_vpc.eks_vpc: Creation complete after 2s [id=vpc-0e2b70ca0ccfdc9e6]
aws_subnet.private_subnet_2: Creating...
aws_subnet.private_subnet_1: Creating...
aws_subnet.private_subnet_1: Creation complete after 0s [id=subnet-090d0f818540848e8]
aws_subnet.private_subnet_2: Creation complete after 0s [id=subnet-012b3c531b4c1d349]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
