## Example of [terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install) config for AWS ([localstack](https://docs.localstack.cloud/getting-started/installation))

```bash
export LOCALSTACK_SERVICES="s3,sts,ec2,dynamodb"
localstack start
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_ENDPOINT_URL=http://localhost:4566
```
#### Create S3 bucket
```bash
aws --endpoint-url=http://localhost:4566 s3 mb s3://dev-terragrunt-states-backend-dev
```
#### Create DynamoDB table for locks
```bash
aws --endpoint-url=http://localhost:4566 dynamodb create-table \
    --table-name dev-terragrunt-states-backend-dev \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```
#### Checking S3 bucket
```bash
aws --endpoint-url=http://localhost:4566 s3 ls
```
#### Checking DynamoDB table
```bash
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
```
#### Checking status of services of localstack 
```bash
curl http://localhost:4566/_localstack/health | jq
```
#### Install infra
```bash
cd dev
terragrunt init
terragrunt run-all plan
terragrunt run-all apply
terragrunt run-all destroy
```

Install and use tflocal if you need but here is terragrunt:
```bash
sudo apt install pipx
pipx ensurepath
pipx install terraform-local
```
```bash
terraform init -backend-config="bucket=dev-terragrunt-states-backend-dev" -backend-config="key=./terraform.tfstate" -backend-config="region=us-east-1" -backend-config="endpoint=http://localhost:4566" -reconfigure
```