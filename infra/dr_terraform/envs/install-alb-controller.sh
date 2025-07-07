#!/bin/bash

set -e

# 환경 설정
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
cd "$WORKDIR"

echo "[INFO] Terraform output 값 읽는 중..."

# terraform output 값 로드
CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw region)
IAM_ROLE_ARN=$(terraform output -raw alb_irsa_role_arn)
VPC_ID=$(terraform output -raw vpc_id)

# 상수 설정
SERVICE_ACCOUNT_NAMESPACE="kube-system"
SERVICE_ACCOUNT_NAME="alb-controller-sa"
ALB_CHART_VERSION="1.7.1"

# 연결 상태 확인
echo "[INFO] 현재 연결된 클러스터:"
kubectl config current-context

# ServiceAccount 생성
echo "[INFO] ServiceAccount 생성 중..."
kubectl create serviceaccount ${SERVICE_ACCOUNT_NAME} \
  -n ${SERVICE_ACCOUNT_NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# IRSA annotation 추가
echo "[INFO] ServiceAccount에 IRSA 연결 중..."
kubectl annotate serviceaccount ${SERVICE_ACCOUNT_NAME} \
  -n ${SERVICE_ACCOUNT_NAMESPACE} \
  eks.amazonaws.com/role-arn=${IAM_ROLE_ARN} --overwrite

# Helm repo 추가
echo "[INFO] Helm repo 등록 중..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Helm 설치
echo "[INFO] Helm Chart로 ALB Controller 설치 중..."
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n ${SERVICE_ACCOUNT_NAMESPACE} \
  --set clusterName=${CLUSTER_NAME} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=${SERVICE_ACCOUNT_NAME} \
  --set region=${REGION} \
  --set vpcId=${VPC_ID} \
  --set image.tag="v${ALB_CHART_VERSION}"

echo "[SUCCESS] ALB Controller가 설치되었습니다."

