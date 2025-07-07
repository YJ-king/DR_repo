#!/bin/bash
set -e

echo "▶️ thumbprint 자동 추출 시작"

# 1. OIDC Domain 추출
OIDC_ISSUER=$(aws eks describe-cluster --name dr-eks-cluster --query "cluster.identity.oidc.issuer" --output text)
OIDC_DOMAIN=$(echo "$OIDC_ISSUER" | sed 's/^https:\/\///' | cut -d'/' -f1)

# 2. Thumbprint 추출
THUMBPRINT=$(openssl s_client -showcerts -connect ${OIDC_DOMAIN}:443 </dev/null 2>/dev/null \
  | openssl x509 -fingerprint -noout \
  | sed 's/^.*=//' | sed 's/://g' | tr 'A-Z' 'a-z')

echo "✅ 추출된 thumbprint: $THUMBPRINT"

# 3. terraform.tfvars에 반영 (있으면 덮어쓰기)
sed -i "s/^thumbprint *= *.*/thumbprint = \"$THUMBPRINT\"/" terraform.tfvars

# 4. Terraform 실행
terraform init
terraform apply -auto-approve

