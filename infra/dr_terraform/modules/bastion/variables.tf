variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "public_subnet_id" {
  type        = string
  description = "ID of public subnet to place the bastion host in"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security Group ID to attach to bastion"
}

variable "ec2_key_pair" {
  type        = string
  description = "Name of the EC2 key pair"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "Instance type for the bastion host"
}

variable "ubuntu_owner_id" {
  type        = string
  default     = "099720109477"
  description = "Canonical's AWS account ID"
}

variable "ubuntu_ami_filter" {
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"
  description = "Filter for Ubuntu AMI name"
}

variable "startup_script" {
  type        = string
  default     = ""
  description = "Path to optional startup script file"
}

variable "bastion_ami_id" {
  type        = string
  description = "AMI ID to use for bastion host"
}
