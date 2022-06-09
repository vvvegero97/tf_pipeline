variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "terraform_state_aws_eu_north_1"
}

variable "state_bucket" {
  description = "S3 bucket for holding Terraform state files. Must be globally unique."
  type        = string
  default     = "vegero-tfstate-bucket"
}

variable "aws_region" {
  description = "AWS Region for the S3 and DynamoDB"
  type        = string
  default     = "eu-north-1"
}
