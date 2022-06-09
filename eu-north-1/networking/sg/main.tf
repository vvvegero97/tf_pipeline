terraform {
  backend "s3" {
    # profile        = "terraformuser"
    bucket         = "vegero-tfstate-bucket"
    encrypt        = true
    key            = "AWS/Dev/terraform-remote-states/eu-north-1/Networking/SG/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform_state_aws_eu_north_1"
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
  # profile = "terraformuser"
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

locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = var.vpc_bucket
    region = var.region
  }
}

resource "aws_security_group" "additional" {
  name_prefix = "${local.name}-additional"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }

  tags = local.tags
}
