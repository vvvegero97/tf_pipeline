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
      version = ">= 3.72"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
 # shared_credentials_file = "~/.aws/credentials"
  profile                 = "terraformuser"
  region                  = "eu-north-1"
}
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}