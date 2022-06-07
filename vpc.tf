module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.0.0"

    name = "Terraform-vpc"
    cidr = "10.1.0.0/16"
    azs = ["eu-north-1c"]
    private_subnets = ["10.1.1.0/24"]
    #public_subnets = ["10.1.101.0/24"]
}