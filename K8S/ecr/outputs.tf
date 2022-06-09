output "repo_name" {
  description = "Repository name: "
  value       = aws_ecr_repository.ecr.name
}
output "repo_url" {
  description = "Repository URL: "
  value       = aws_ecr_repository.ecr.repository_url
}
output "registry_id" {
  description = "Registry ID: "
  value       = aws_ecr_repository.ecr.registry_id
}
