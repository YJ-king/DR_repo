### DB Subnet Group (Private 서브넷 2개로 구성)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

### RDS 인스턴스 (Single-AZ, MySQL)
resource "aws_db_instance" "rds" {
  identifier              = "${var.name_prefix}-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  username                = var.db_user
  password                = var.db_password
  db_name                 = var.db_name
  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = false
  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  multi_az                = false # 테스트용으로 단일 AZ
  availability_zone       = var.availability_zone
  backup_retention_period = 0
}
