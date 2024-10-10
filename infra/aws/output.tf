output "oidc_arn" {
  value = aws_iam_openid_connect_provider.main.arn
}

output "iam_role_arn" {
  value = aws_iam_role.for_azure.arn
}
