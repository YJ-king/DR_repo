# scripts/gen-aws-auth.sh (리포지토리에 저장)
cat <<EOF > infra/dr_terraform/envs/aws-auth.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${NODE_ROLE_ARN}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::723165663216:user/kdt005
      username: kdt005
      groups:
        - system:masters
EOF

