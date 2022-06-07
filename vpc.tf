module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.0.0"

    name = "Terraform-vpc"
    cidr = "10.1.0.0/16"
    azs = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    #public_subnets = ["10.1.101.0/24"]
}

output "pr_subnet_ids" {
    description = "Private Subnet ID's: "
    value = module.vpc.private_subnets
}
output "pr_subnet_cidr" {
    description = "Private Subnet CIDR blocks: "
    value = module.vpc.private_subnets_cidr_blocks
}