
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

resource "aws_launch_template" "eks" {
  name_prefix   = "${var.name_prefix}-eks-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ec2_key_pair

  vpc_security_group_ids = var.eks_sg_ids

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-eks-node"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_eks_cluster.this]
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
    id      = aws_launch_template.eks.id
    version = "$Latest"
  }

  capacity_type = "ON_DEMAND"

  tags = {
    Name = "${var.name_prefix}-eks-node"
  }

  depends_on = [aws_eks_cluster.this, aws_launch_template.eks]
}
