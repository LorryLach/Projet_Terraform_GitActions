resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-web-server-sg"
  description = "Security group for Nginx web server"
  vpc_id      = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-web-server-sg"
  }
}


resource "aws_security_group_rule" "web_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.web_server.id
  description       = "Allow HTTP traffic from anywhere"
}


resource "aws_security_group_rule" "web_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.web_server.id
  description       = "Allow HTTPS traffic from anywhere"
}


resource "aws_security_group_rule" "web_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  
  security_group_id = aws_security_group.web_server.id
  description       = "Allow SSH access (restrict in production!)"
}


resource "aws_security_group_rule" "web_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
  description       = "Allow all outbound traffic"
}



resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}


resource "aws_security_group_rule" "rds_mysql_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_server.id  
  security_group_id        = aws_security_group.rds.id
  description              = "Allow MySQL traffic from web server only"
}


resource "aws_security_group_rule" "rds_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
  description       = "Allow all outbound traffic"
}