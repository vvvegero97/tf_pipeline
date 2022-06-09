terraform {
  backend "s3" {
    profile        = "terraformuser"
    bucket         = var.bucket_name
    encrypt        = true
    key            = "AWS/Dev/terraform-remote-states/eu-north-1/K8S/ACR/terraform.tfstate"
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
      "Type"             = "Container Registry"
    }
  }
}

resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name

  image_scanning_configuration {
    scan_on_push = true
  }
}
