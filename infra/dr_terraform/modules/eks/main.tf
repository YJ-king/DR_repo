
# EKS Cluster 생성
resource "aws_eks_cluster" "this" {
  name     = "${var.name_prefix}-eks-cluster"
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = false
    endpoint_public_access  = true
    security_group_ids      = var.eks_sg_ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.100.0.0/16"
  }

}


# EKS Node Group
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.name_prefix}-eks-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  launch_template {
    id      = aws_launch_template.eks_node.id
    version = "$Latest"
  }
  capacity_type = "ON_DEMAND"

  tags = {
    Name = "${var.name_prefix}-eks-node"
  }

  depends_on = [aws_eks_cluster.this, aws_launch_template.eks_node]
}

resource "aws_launch_template" "eks_node" {
  name_prefix   = "${var.name_prefix}-eks-lt-"
  image_id      = "ami-0b6e395f5b26f749c"
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
    var.eks_sg_ids[0]
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    /etc/eks/bootstrap.sh ${var.name_prefix}-eks-cluster
  EOF
  )
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }


}
