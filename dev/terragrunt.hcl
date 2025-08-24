remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    path = "terragrunt.tfstate"
  }
}

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

#remote_state {
#  backend = "s3"
#  generate = {
#    path      = "backend.tf"
#    if_exists = "overwrite_terragrunt"
#  }
#  config = {
#    bucket              = "${local.deployment_prefix}-terragrunt-states-backend-dev"
#    key                 = "${path_relative_to_include()}/terraform.tfstate"
#    region              = local.aws_region
#    encrypt             = true
#    dynamodb_table      = "${local.deployment_prefix}-terragrunt-states-backend-dev"
#    acl                 = "bucket-owner-full-control"
#    s3_bucket_tags      = local.default_tags
#    dynamodb_table_tags = local.default_tags
#    access_key          = "test"
#    secret_key          = "test"
#    force_path_style    = true
#  }
#}

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
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
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
