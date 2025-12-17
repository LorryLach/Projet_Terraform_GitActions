# nat-gateway.tf
# Configuration du NAT Gateway pour permettre aux ressources privées d'accéder à Internet

# Elastic IP pour le NAT Gateway
# Une EIP est une adresse IP publique statique
resource "aws_eip" "nat" {
  domain = "vpc"  # Spécifie que cette EIP est pour le VPC
  
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
  
  # Dépend de l'Internet Gateway (important pour l'ordre de création)
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway - Permet aux ressources privées d'accéder à Internet
# pour les mises à jour, téléchargements, etc., sans être accessibles depuis Internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # Doit être dans un sous-réseau public
  
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
  
  # Le NAT Gateway dépend de l'Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

# Route pour le trafic sortant des sous-réseaux privés vers le NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"  # Tout le trafic Internet
  nat_gateway_id         = aws_nat_gateway.main.id
}