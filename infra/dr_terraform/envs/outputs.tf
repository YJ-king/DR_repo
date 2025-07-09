output "region" {
  value = var.region
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "alb_irsa_role_arn" {
  value = module.irsa_alb.alb_irsa_role_arn
}

output "rds_endpoint" {
  value = try(module.rds.rds_endpoint, "unavailable")
}

output "eks_node_role_arn" {
  value = module.iam.eks_node_role_arn
}

