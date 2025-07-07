#!/bin/bash

set -e

### 1. 필수 패키지 설치
apt-get update -y
apt-get install -y curl unzip git docker.io apt-transport-https ca-certificates gnupg lsb-release jq

### 2. AWS CLI 설치
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws

### 3. kubectl 설치
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

### 4. Helm 설치
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

### 5. GitHub 리포지토리 클론 및 디렉토리 이동
cd /home/ubuntu
git clone https://github.com/${github_repo}.git
mkdir -p k8s
mv ${github_repo}/aws-auth.yaml ./k8s/
mv ${github_repo}/web ./k8s/
mv ${github_repo}/was ./k8s/
rm -rf ${github_repo}

### 6. EKS 연결
aws eks update-kubeconfig --region ${aws_region} --name ${cluster_name}

### 7. aws-auth 설정
kubectl apply -f /home/ubuntu/k8s/aws-auth.yaml

### 8. ALB Controller 설치
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${cluster_name} \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=${aws_region} \
  --set vpcId=$(aws eks describe-cluster --name ${cluster_name} --region ${aws_region} --query "cluster.resourcesVpcConfig.vpcId" --output text) \
  --set image.repository=602401143452.dkr.ecr.${aws_region}.amazonaws.com/amazon/aws-load-balancer-controller

### 9. Web/WAS YAML 배포
kubectl apply -f /home/ubuntu/k8s/web/
kubectl apply -f /home/ubuntu/k8s/was/

### 10. 권한 설정
usermod -aG docker ubuntu
chown -R ubuntu:ubuntu /home/ubuntu
