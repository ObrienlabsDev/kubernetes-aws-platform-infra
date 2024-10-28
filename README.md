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
