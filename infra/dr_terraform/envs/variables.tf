variable "name_prefix" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr_a" {}
variable "public_subnet_cidr_c" {}
variable "private_subnet_cidr_a" {}
variable "private_subnet_cidr_c" {}

variable "public_subnet_az_a" {}
variable "public_subnet_az_c" {}
variable "private_subnet_az_a" {}
variable "private_subnet_az_c" {}

variable "ec2_key_pair" {
  type = string
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "thumbprint" {
  type = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ami_id" {
  type = string
}
