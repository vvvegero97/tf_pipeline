terraform {
    backend "s3" {
        profile = "terraformuser"
        bucket = "vegerotfstatebucket"
        encrypt = "true"
        key = "AWS/Dev/terraform-remote-states/terraform.tfstate"
        region = "eu-north-1"
    }
    required_providers {
        aws = {
            version = "~> 3.0"
        }
    }
    required_version = ">= 0.13"
}

provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile = "terraformuser"
  region = "eu-north-1"
}