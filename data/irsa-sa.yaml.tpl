apiVersion: v1
kind: ServiceAccount
metadata:
  name: irsa-s3-access
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: ${S3_ROLE_ARN}
