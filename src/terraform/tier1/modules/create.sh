

terraform init
terraform plan
terraform apply -auto-approve
aws eks update-cluster-config --name example-eks-cluster --upgrade-policy supportType=STANDARD --region us-east-1
