# Security Groups - Generados automáticamente con mejores prácticas

resource "aws_security_group" "alb" {
  name_prefix = "genai-alb-${var.name_suffix}-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "alb-security-group-${var.name_suffix}"
    GeneratedBy = "AI"
  }
}

resource "aws_security_group" "web" {
  name_prefix = "genai-web-${var.name_suffix}-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "web-security-group-${var.name_suffix}"
    GeneratedBy = "AI"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "genai-rds-${var.name_suffix}-"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  
  tags = {
    Name = "rds-security-group-${var.name_suffix}"
    GeneratedBy = "AI"
  }
}
