
resource "aws_instance" "bastion" {
  ami                         = var.bastion_ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.ec2_key_pair
  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-bastion"
  }

  user_data = var.startup_script != "" ? var.startup_script : null
}

