variable "bucket_name" {
  type        = string
  description = "S3 Bucket for Backend tfstate"
  default     = "vegero-tfstate-bucket"
}

variable "region" {
  type        = string
  description = "AWS Region for Backend"
  default     = "eu-north-1"
}

variable "dynamodb_table" {
  type        = string
  description = "DynamoDB Table for State Lock"
  default     = "terraform_state_aws_eu_north_1"
}

variable "vpc_bucket" {
  type        = string
  description = "VPC Remote State File Path"
  default     = "AWS/Dev/terraform-remote-states/eu-north-1/Networking/VPC/terraform.tfstate"
}

variable "sg_bucket" {
  type        = string
  description = "SG Remote State File Path"
  default     = "AWS/Dev/terraform-remote-states/eu-north-1/Networking/SG/terraform.tfstate"
}
