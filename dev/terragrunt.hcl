#remote_state {
#  backend = "local"
#  generate = {
#    path      = "backend.tf"
#    if_exists = "overwrite_terragrunt"
#  }
#  config = {
#    path = "terragrunt.tfstate"
#  }
#}

# Удаляем дублирующиеся блоки locals и inputs
locals {
  source_version    = "v0.1.2"
  aws_region        = "us-east-1"
  deployment_prefix = "dev"

  eks_cluster_name = "${local.deployment_prefix}-eks-cluster"
  default_tags = {
    TerminationDate  = "Permanent",
    Environment      = "Development",
    Team             = "DevOps",
    DeployedBy       = "Terragrunt",
    OwnerEmail       = "nodegopher@gmail.com",
    DeploymentPrefix = local.deployment_prefix
  }
}

inputs = {
  aws_region        = local.aws_region
  deployment_prefix = local.deployment_prefix
  default_tags      = local.default_tags
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket              = "${local.deployment_prefix}-terragrunt-states-backend-demo"
    key                 = "${path_relative_to_include()}/terragrunt.tfstate"
    region              = local.aws_region
    encrypt             = true
    dynamodb_table      = "${local.deployment_prefix}-terragrunt-states-backend-demo"
    s3_bucket_tags      = local.default_tags
    dynamodb_table_tags = local.default_tags
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region     = "${local.aws_region}"
  access_key = "test"
  secret_key = "test"

  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2        = "http://localhost:4566"
    apigateway = "http://localhost:4566"
    dynamodb   = "http://localhost:4566"
    iam        = "http://localhost:4566"
    kinesis    = "http://localhost:4566"
    lambda     = "http://localhost:4566"
    s3         = "http://s3.localhost.localstack.cloud:4566"
    ses        = "http://localhost:4566"
    sns        = "http://localhost:4566"
    sqs        = "http://localhost:4566"
    sts        = "http://localhost:4566"
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
EOF
}
