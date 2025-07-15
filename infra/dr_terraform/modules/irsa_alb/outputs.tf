output "alb_irsa_role_arn" {
  description = "IAM Role ARN to be used in Kubernetes ServiceAccount for ALB Controller"
  value       = aws_iam_role.alb_controller_irsa.arn
}

output "alb_oidc_arn" {
  description = "OIDC Provider ARN"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

