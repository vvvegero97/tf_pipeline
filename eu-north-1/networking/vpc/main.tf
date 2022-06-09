terraform {
  backend "s3" {
    profile        = "terraformuser"
    bucket         = var.bucket_name
    encrypt        = "true"
    key            = "AWS/Dev/terraform-remote-states/Networking/VPC/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.dynamodb_table
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  # shared_credentials_file = "~/.aws/credentials"
  profile = "terraformuser"
  region  = var.region
  default_tags {
    tags = {
      "Termination date" = "Permanent"
      "Environment"      = "Development"
      "Team"             = "DevOps"
      "DeployedBy"       = "Terraformm"
      "Description"      = "For General Purposes"
      "OwnerEmail"       = "devops@example.com"
      "Type"             = "Networking"
    }
  }
}

data "aws_availability_zones" "available" {}

locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = 1
  }

  tags = local.tags
}
