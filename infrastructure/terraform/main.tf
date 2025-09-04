# Demo 1: Infraestructura Generada Automáticamente
# Prompt: "Crear infraestructura para aplicación web escalable con base de datos"

# VPC y Networking
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "genai-devops-vpc-${var.name_suffix}"
    Environment = var.environment
    GeneratedBy = "AI"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "private-subnet-${count.index + 1}-${var.name_suffix}"
    Type = "Private"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 10}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${count.index + 1}-${var.name_suffix}"
    Type = "Public"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "web" {
  name                = "web-asg-${var.name_suffix}"
  vpc_zone_identifier = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"
  
  min_size         = 2
  max_size         = 10
  desired_capacity = 3
  
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  
  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

# RDS Aurora Serverless v2
resource "aws_rds_cluster" "main" {
  cluster_identifier = "genai-app-cluster-${var.name_suffix}"
  engine            = "aurora-mysql"
  engine_mode       = "provisioned"
  engine_version    = "8.0.mysql_aurora.3.07.1"
  
  database_name   = "genaiapp"
  master_username = "admin"
  manage_master_user_password = true
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  serverlessv2_scaling_configuration {
    max_capacity = 16
    min_capacity = 0.5
  }
  
  skip_final_snapshot = true
  
  tags = {
    Name        = "genai-aurora-cluster-${var.name_suffix}"
    Environment = var.environment
    GeneratedBy = "AI"
  }
}

# Load Balancer
resource "aws_lb" "main" {
  name               = "genai-alb-${var.name_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
  
  tags = {
    Name        = "genai-load-balancer-${var.name_suffix}"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
