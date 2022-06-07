# module "ecr" {
#     source = "github.com/byu-oit/terraform-aws-ecr?ref=v2.0.1"
#     name = "vegero-example-ecr"
# }

# output "repository" {
#     value = module.ecr.repository
# }

# output "lifecycle_policy" {
#     value = module.ecr.lifecycle_policy
# }

# output "repository_policy" {
#     value = module.ecr.repository_policy
# }
################################################################
resource "aws_ecr_repository" "ecr" {
    name = "vegero-example-ecr"

    image_scanning_configuration {
    scan_on_push = true
  }
}

output "repo_name" {
description = "Repository name: "
  value = aws_ecr_repository.ecr.name
}
output "repo_url" {
    description = "Repository URL: "
  value = aws_ecr_repository.ecr.repository_url
}
output "registry_id" {
    description = "Registry ID: "
  value = aws_ecr_repository.ecr.registry_id
}