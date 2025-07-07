output "alb_irsa_role_arn" {
  description = "IAM Role ARN to be used in Kubernetes ServiceAccount for ALB Controller"
  value       = aws_iam_role.alb_controller_irsa.arn
}

