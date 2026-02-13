output "role_arn" {
  description = "Role ARN for GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}
