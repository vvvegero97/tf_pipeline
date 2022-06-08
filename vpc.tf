variable "region" {
  default     = "eu-north-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "vegero-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "vegero-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
##################################################################################
# module "vpc" {
#     source = "terraform-aws-modules/vpc/aws"
#     version = "3.0.0"

#     name = "Terraform-vpc"
#     cidr = "10.1.0.0/16"
#     azs = ["eu-north-1a", "eu-north-1b"]
#     private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
#     public_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]
#     private_subnet_tags = {
#       "kubernetes.io/role/internal-elb" = "1"
#       "kubernetes.io/cluster/mydemocluster" = "owned"
#     }
#     public_subnet_tags = {
#       "kubernetes.io/role/elb" = "1"
#       "kubernetes.io/cluster/mydemocluster" = "owned"
#     }

# }

# resource "aws_internet_gateway" "igw" {
#     vpc_id = module.vpc.default_vpc_id
# }
