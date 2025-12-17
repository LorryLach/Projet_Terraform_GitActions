# security-groups.tf
# Configuration des Security Groups (pare-feu virtuels)

# ============================================
# SECURITY GROUP POUR LE WEB SERVER (Public)
# ============================================

resource "aws_security_group" "web_server" {
  name        = "${var.project_name}-web-server-sg"
  description = "Security group for Nginx web server"
  vpc_id      = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-web-server-sg"
  }
}

# Règle entrante: HTTP (port 80)
resource "aws_security_group_rule" "web_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Accessible depuis Internet
  security_group_id = aws_security_group.web_server.id
  description       = "Allow HTTP traffic from anywhere"
}

# Règle entrante: HTTPS (port 443)
resource "aws_security_group_rule" "web_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # Accessible depuis Internet
  security_group_id = aws_security_group.web_server.id
  description       = "Allow HTTPS traffic from anywhere"
}

# Règle entrante: SSH (port 22) - pour l'administration
resource "aws_security_group_rule" "web_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # ATTENTION: en production, limiter à ton IP!
  security_group_id = aws_security_group.web_server.id
  description       = "Allow SSH access (restrict in production!)"
}

# Règle sortante: Tout le trafic autorisé
resource "aws_security_group_rule" "web_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"  # Tous les protocoles
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_server.id
  description       = "Allow all outbound traffic"
}

# ============================================
# SECURITY GROUP POUR RDS DATABASE (Privé)
# ============================================

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Règle entrante: MySQL/Aurora (port 3306) - seulement depuis le web server
resource "aws_security_group_rule" "rds_mysql_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_server.id  # Seulement depuis le web SG
  security_group_id        = aws_security_group.rds.id
  description              = "Allow MySQL traffic from web server only"
}

# Règle sortante: Tout le trafic autorisé (nécessaire pour les mises à jour)
resource "aws_security_group_rule" "rds_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
  description       = "Allow all outbound traffic"
}