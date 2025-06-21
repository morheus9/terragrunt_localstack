## Example of [terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install) config for AWS ([localstack](https://docs.localstack.cloud/getting-started/installation))

```bash
localstack start
cd environments/local
terragrunt init
terragrunt plan
terragrunt apply
```



install tflocal if you need:
```bash
sudo apt install pipx
pipx ensurepath
pipx install terraform-local
```