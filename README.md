## Example of [terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install) config for AWS ([localstack](https://docs.localstack.cloud/getting-started/installation))

```bash
localstack start
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
cd dev
terragrunt init
terragrunt plan
terragrunt apply
```
Check status of services of localstack 
```bash
curl http://localhost:4566/_localstack/health | jq
```




install tflocal if you need but here is terragrunt:
```bash
sudo apt install pipx
pipx ensurepath
pipx install terraform-local
```