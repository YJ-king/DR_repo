resource "aws_security_group_rule" "rds_ingress_from_eks" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.security.rds_sg_id
  source_security_group_id = module.security.eks_node_sg_id
}

resource "aws_security_group_rule" "allow_cluster_to_node_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.security.eks_node_sg_id
  source_security_group_id = module.eks.cluster_security_group_id # 클러스터 SG
  description              = "Allow EKS Control Plane to access node on port 443"
}

resource "aws_iam_role_policy_attachment" "eks_node_SSM" {
  role       = module.iam.eks_node_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "network" {
  source = "../modules/network"

  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr_a  = var.public_subnet_cidr_a
  public_subnet_cidr_c  = var.public_subnet_cidr_c
  private_subnet_cidr_a = var.private_subnet_cidr_a
  private_subnet_cidr_c = var.private_subnet_cidr_c
  public_subnet_az_a    = var.public_subnet_az_a
  public_subnet_az_c    = var.public_subnet_az_c
  private_subnet_az_a   = var.private_subnet_az_a
  private_subnet_az_c   = var.private_subnet_az_c

}

module "security" {
  source      = "../modules/security"
  vpc_id      = module.network.vpc_id
  name_prefix = var.name_prefix
}

module "iam" {
  source      = "../modules/iam"
  name_prefix = var.name_prefix
}

module "eks" {
  source             = "../modules/eks"
  name_prefix        = var.name_prefix
  private_subnet_ids = module.network.private_subnet_ids
  eks_sg_ids         = [module.security.eks_node_sg_id]
  ec2_key_pair       = var.ec2_key_pair
  eks_role_arn       = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  desired_size       = var.desired_size
  min_size           = var.min_size
  max_size           = var.max_size
  instance_type      = var.instance_type
  depends_on         = [module.iam, module.security, module.network]
}

module "rds" {
  source             = "../modules/rds"
  name_prefix        = var.name_prefix
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  rds_sg_id          = module.security.rds_sg_id
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  db_user            = var.db_user
  db_password        = var.db_password
  db_name            = var.db_name
  availability_zone  = var.private_subnet_az_a
  depends_on         = [module.network, module.security]
}

module "irsa_alb" {
  source           = "../modules/irsa_alb"
  name_prefix      = var.name_prefix
  cluster_oidc_url = module.eks.oidc_issuer_url
  thumbprint       = var.thumbprint
  # dummy comment added
  depends_on = [module.eks]
}

module "irsa_s3" {
  source      = "../modules/irsa_s3"
  name_prefix = var.name_prefix
  oidc_url    = module.eks.oidc_issuer_url
  oidc_arn    = module.irsa_alb.alb_oidc_arn

  depends_on = [module.irsa_alb]
}

