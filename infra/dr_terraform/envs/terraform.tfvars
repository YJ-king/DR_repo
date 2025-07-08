region = "ap-northeast-2"

name_prefix = "drb"
vpc_name    = "dr-vpc"
vpc_cidr    = "10.0.0.0/16"

public_subnet_cidr_a  = "10.0.1.0/24"
public_subnet_cidr_c  = "10.0.11.0/24"
private_subnet_cidr_a = "10.0.2.0/24"
private_subnet_cidr_c = "10.0.22.0/24"

public_subnet_az_a  = "ap-northeast-2a"
public_subnet_az_c  = "ap-northeast-2c"
private_subnet_az_a = "ap-northeast-2a"
private_subnet_az_c = "ap-northeast-2c"

ec2_key_pair  = "dr-key"
instance_type = "t3.medium"
desired_size  = 2
min_size      = 1
max_size      = 3

instance_class    = "db.t3.micro"
allocated_storage = 20
db_user           = "admin"
db_password       = "admin1234"
db_name           = "petclinic"

eks_cluster_name = "drb-eks-cluster"
thumbprint       = "1bbb4ba787ef7707f4ecbc612587ec28805cffc4"

