

```sh
cd web-app/aws

terraform init -backend-config=backend.config
terraform fmt && terraform validate

terraform plan
terraform apply -auto-approve

terraform destroy -auto-approve
```