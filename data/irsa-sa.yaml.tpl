apiVersion: v1
kind: ServiceAccount
metadata:
  name: irsa-s3-access
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::723165663216:role/drb-s3-restore-role
