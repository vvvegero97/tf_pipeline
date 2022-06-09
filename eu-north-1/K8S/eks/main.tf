terraform {
  backend "s3" {
    profile        = "terraformuser"
    bucket         = var.bucket_name
    encrypt        = true
    key            = "AWS/Dev/terraform-remote-states/K8S/EKS_clusters/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.dynamodb_table
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
  profile = "terraformuser"
  region  = var.region
  tags = {
    "Termination date" = "Permanent"
    "Environment"      = "Development"
    "Team"             = "DevOps"
    "DeployedBy"       = "Terraformm"
    "Description"      = "For Geberal Purposes"
    "OwnerEmail"       = "devops@example.com"
    "Type"             = "EKS K8S Cluster"
  }
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

################################################################################
locals {
  name   = "ex-${replace(basename(path.cwd), "_", "-")}"
  region = var.region

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

#Get existing VPC state
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = var.vpc_bucket
    region = var.region
  }
}

#Get existing SG state
data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = var.sg_bucket
    region = var.region
  }
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = local.name
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.micro", "t3.small"]

    attach_cluster_primary_security_group = true
    vpc_security_group_ids                = [data.terraform_remote_state.sg.outputs.sg_id]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t3.micro"]
      capacity_type  = "SPOT"
      labels = {
        Environment = "test"
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }

      taints = {
        dedicated = {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      }

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }

      tags = {
        ExtraTag = "example"
      }
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = false

  tags = local.tags


  resource "aws_kms_key" "eks" {
    description             = "EKS Secret Encryption Key"
    deletion_window_in_days = 7
    enable_key_rotation     = true

    tags = local.tags
  }
}
