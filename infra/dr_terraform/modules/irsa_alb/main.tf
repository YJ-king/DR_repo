# OIDC Provider
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [var.thumbprint]
  url             = var.cluster_oidc_url

  tags = {
    Name = "${var.name_prefix}-oidc-provider"
  }
}

# ALB Controller용 IAM Policy (JSON 파일로부터 로드)
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.name_prefix}-alb-controller-policy"
  description = "Policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json")
}

# IAM Role for ServiceAccount (IRSA)
resource "aws_iam_role" "alb_controller_irsa" {
  name = "${var.name_prefix}-alb-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.oidc_provider.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.cluster_oidc_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

# IAM Policy → Role에 Attach
resource "aws_iam_role_policy_attachment" "alb_policy_attach" {
  policy_arn = aws_iam_policy.alb_controller_policy.arn
  role       = aws_iam_role.alb_controller_irsa.name
}

