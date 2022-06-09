variable "ecr_name" {
  type        = string
  description = "Name for Container Registry"
  default     = "vegero-example-ecr"
}

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
