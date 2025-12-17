# rds.tf
# Configuration de la base de données RDS (Single-AZ)

# Subnet Group pour RDS - définit où RDS peut être déployé
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id  # Utilise tous les sous-réseaux privés
  
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Instance RDS Primary (dans Private Subnet 1, AZ-A)
resource "aws_db_instance" "primary" {
  identifier     = "${var.project_name}-db-primary"
  engine         = "mysql"
  engine_version = "8.0"
  
  # Configuration de l'instance
  instance_class        = var.db_instance_class
  allocated_storage     = 20  # 20 GB (minimum pour le free tier)
  storage_type          = "gp3"
  storage_encrypted     = true
  max_allocated_storage = 100  # Autoscaling jusqu'à 100GB si nécessaire
  
  # Configuration de la base de données
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 3306
  
  # Configuration réseau
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false  # Important: ne pas exposer sur Internet
  
  # Single-AZ deployment (no high availability)
  multi_az = false  # Deploiement dans une seule AZ
  
  # Configuration de backup
  backup_retention_period = 7  # Garde les backups pendant 7 jours
  backup_window          = "03:00-04:00"  # Fenêtre de backup (UTC)
  maintenance_window     = "Mon:04:00-Mon:05:00"  # Fenêtre de maintenance
  
  # Options de suppression (ATTENTION en production!)
  skip_final_snapshot       = true  # Pour le sandbox, on skip le snapshot final
  deletion_protection       = false  # Pour pouvoir détruire facilement en test
  delete_automated_backups  = true
  
  # Monitoring
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]
  monitoring_interval             = 60  # Monitoring détaillé toutes les 60 secondes
  
  # Performance Insights (utile pour le monitoring)
  performance_insights_enabled = true
  performance_insights_retention_period = 7
  
  tags = {
    Name = "${var.project_name}-db-primary"
    Role = "Database"
    Type = "Primary"
  }
}

# Note: Cette instance RDS fonctionne en mode Single-AZ
# Pas de replica automatique - convient pour dev/test mais pas pour production