terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.7"
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  cidr_part = trimsuffix(var.cidr, ".0.0")
}

module "vpc" {
  source                 = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v6.0.1"
  name                   = "${var.deployment_prefix}-VPC"
  cidr                   = "${var.cidr}/16"
  azs                    = data.aws_availability_zones.available.names
  private_subnets        = ["${local.cidr_part}.1.0/24", "${local.cidr_part}.2.0/24", "${local.cidr_part}.3.0/24"]
  public_subnets         = ["${local.cidr_part}.21.0/24", "${local.cidr_part}.22.0/24", "${local.cidr_part}.23.0/24"]
  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
