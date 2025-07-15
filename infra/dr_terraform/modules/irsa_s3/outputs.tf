
output "role_arn" {
  value       = aws_iam_role.s3_restore_irsa.arn
  description = "S3 Restore IRSA Role ARN"
}

