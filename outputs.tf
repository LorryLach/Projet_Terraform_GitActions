# outputs.tf
# Définit les informations à afficher après le déploiement

# ============================================
# INFORMATIONS VPC
# ============================================

output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block du VPC"
  value       = aws_vpc.main.cidr_block
}

# ============================================
# INFORMATIONS SOUS-RÉSEAUX
# ============================================

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés"
  value       = aws_subnet.private[*].id
}

# ============================================
# INFORMATIONS WEB SERVER
# ============================================

output "web_server_id" {
  description = "ID de l'instance EC2 web server"
  value       = aws_instance.web_server.id
}

output "web_server_public_ip" {
  description = "Adresse IP publique du web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_public_dns" {
  description = "DNS public du web server"
  value       = aws_instance.web_server.public_dns
}

output "web_server_url" {
  description = "URL pour accéder au web server"
  value       = "http://${aws_instance.web_server.public_ip}"
}

# ============================================
# INFORMATIONS NAT GATEWAY
# ============================================

output "nat_gateway_ip" {
  description = "Adresse IP publique du NAT Gateway"
  value       = aws_eip.nat.public_ip
}

# ============================================
# INFORMATIONS RDS
# ============================================

output "rds_endpoint" {
  description = "Endpoint de connexion à la base de données"
  value       = aws_db_instance.primary.endpoint
}

output "rds_address" {
  description = "Adresse DNS de la base de données"
  value       = aws_db_instance.primary.address
}

output "rds_port" {
  description = "Port de connexion à la base de données"
  value       = aws_db_instance.primary.port
}

output "rds_database_name" {
  description = "Nom de la base de données"
  value       = aws_db_instance.primary.db_name
}

output "rds_username" {
  description = "Nom d'utilisateur de la base de données"
  value       = aws_db_instance.primary.username
  sensitive   = true
}

# ============================================
# INFORMATIONS DE CONNEXION
# ============================================

output "connection_instructions" {
  description = "Instructions de connexion"
  value = <<-EOT
  
  ╔════════════════════════════════════════════════════════════════╗
  ║          DÉPLOIEMENT RÉUSSI - INSTRUCTIONS D'ACCÈS            ║
  ╚════════════════════════════════════════════════════════════════╝
  
  🌐 WEB SERVER:
     URL: http://${aws_instance.web_server.public_ip}
     SSH: ssh ec2-user@${aws_instance.web_server.public_ip}
  
  🗄️  DATABASE:
     Endpoint: ${aws_db_instance.primary.endpoint}
     Database: ${aws_db_instance.primary.db_name}
     Username: ${aws_db_instance.primary.username}
     
     Connection depuis le web server:
     mysql -h ${aws_db_instance.primary.address} -u ${aws_db_instance.primary.username} -p
  
  📝 NOTES:
     - Le web server est accessible depuis Internet
     - La base de données est dans un sous-réseau privé (Single-AZ)
     - NAT Gateway IP: ${aws_eip.nat.public_ip}
  
  EOT
}