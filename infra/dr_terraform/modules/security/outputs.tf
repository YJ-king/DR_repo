output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

