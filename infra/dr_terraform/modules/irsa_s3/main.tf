
resource "aws_iam_role" "s3_restore_irsa" {
  name = "${var.name_prefix}-s3-restore-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_url, "https://", "")}:sub" = "system:serviceaccount:default:irsa-s3-access"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "s3_restore_policy" {
  name        = "${var.name_prefix}-s3-restore-policy"
  description = "Policy to allow reading backup from S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["s3:GetObject"],
      Resource = "arn:aws:s3:::yj-dr-bucket/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  policy_arn = aws_iam_policy.s3_restore_policy.arn
  role       = aws_iam_role.s3_restore_irsa.name
}

