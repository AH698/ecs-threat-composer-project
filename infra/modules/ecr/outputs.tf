output "repository_url" {
  description = "url of existing ecr repo"
  value       = data.aws_ecr_repository.ecr_repo.repository_url
}