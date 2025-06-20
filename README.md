## Example of terragrung config for AWS ([localstack](https://docs.localstack.cloud/getting-started/installation))
```bash
sudo apt install pipx
pipx ensurepath
pipx install terraform-local
```

```bash
localstack start
cd environments/local
terragrunt init
terragrunt plan
terragrunt apply
```