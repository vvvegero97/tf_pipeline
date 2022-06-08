terraform {
  backend "s3" {
    profile        = "terraformuser"
    bucket         = "vegerotfstatebucket"
    encrypt        = "true"
    key            = "AWS/Dev/terraform-remote-states/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform_state_aws_eu_north_1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraformuser"
  region                  = "eu-north-1"
}