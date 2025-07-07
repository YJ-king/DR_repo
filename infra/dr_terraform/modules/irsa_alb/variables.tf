variable "name_prefix" {
  description = "Prefix for naming IAM and Helm resources"
  type        = string
}

variable "cluster_oidc_url" {
  description = "OIDC issuer URL from EKS cluster (e.g., https://oidc.eks.ap-northeast-2.amazonaws.com/id/...)"
  type        = string
}

variable "thumbprint" {
  description = "Root CA thumbprint for OIDC provider"
  type        = string
}


