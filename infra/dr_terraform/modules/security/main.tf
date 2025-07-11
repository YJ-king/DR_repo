# EKS Node Group SG (Web/WAS Pod용, Ingress ALB 허용 등)
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.name_prefix}-eks-node-sg"
  description = "Security Group for EKS Node Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow node-to-node communication"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-eks-node-sg"
  }
}

# RDS SG (WAS에서 MySQL 접속)
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Allow MySQL from EKS"
  vpc_id      = var.vpc_id

  ingress {
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  security_groups = [aws_security_group.eks_node_sg.id]
  description     = "MySQL from EKS"
}

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

# ALB SG
resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "ALB ingress from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

