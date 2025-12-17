# subnets.tf
# Configuration des sous-réseaux publics et privés

# ============================================
# SOUS-RÉSEAUX PUBLICS (avec accès Internet)
# ============================================

# Crée les sous-réseaux publics dans chaque AZ
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true  # Assigne automatiquement une IP publique
  
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
    Type = "Public"
    AZ   = var.availability_zones[count.index]
  }
}

# Table de routage pour les sous-réseaux publics
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-public-rt"
    Type = "Public"
  }
}

# Route vers Internet via l'Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"  # Tout le trafic Internet
  gateway_id             = aws_internet_gateway.main.id
}

# Association des sous-réseaux publics à la table de routage
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ============================================
# SOUS-RÉSEAUX PRIVÉS (sans accès Internet direct)
# ============================================

# Crée les sous-réseaux privés dans chaque AZ
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
    Type = "Private"
    AZ   = var.availability_zones[count.index]
  }
}

# Table de routage pour les sous-réseaux privés
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-private-rt"
    Type = "Private"
  }
}

# Association des sous-réseaux privés à la table de routage
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}