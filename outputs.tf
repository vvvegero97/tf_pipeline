output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "pr_subnet_ids" {
  description = "Private Subnet ID's: "
  value       = module.vpc.private_subnets
}

output "pr_subnet_cidr" {
  description = "Private Subnet CIDR blocks: "
  value       = module.vpc.private_subnets_cidr_blocks
}

output "pub_subnet_ids" {
  description = "Public Subnet ID's: "
  value       = module.vpc.public_subnets
}

output "pub_subnet_cidr" {
  description = "Public Subnet CIDR blocks: "
  value       = module.vpc.public_subnets_cidr_blocks
}
