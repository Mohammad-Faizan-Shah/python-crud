# Create a security group for RDS
resource "aws_security_group" "rds" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL traffic from EKS nodes only"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "MySQL from EKS nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.all_worker_mgmt.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "MySQL DB subnet group"
  }
}

# Create RDS MySQL instance - Free Tier eligible
resource "aws_db_instance" "mysql" {
  identifier             = "crud-mysql-db"
  allocated_storage      = 20            # Free tier: 20GB
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" # Free tier eligible
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false         # Set to false for free tier
  backup_retention_period = 0            # Disable automated backups for free tier
  apply_immediately      = true

  tags = {
    Name = "crud-mysql-db"
  }
}