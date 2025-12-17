# variables.tf
# Ce fichier déclare toutes les variables que nous utiliserons dans notre infrastructure

# Région AWS où déployer l'infrastructure
variable "aws_region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "us-east-1"  # Irlande - tu peux changer selon ta région sandbox
}

# CIDR du VPC (le bloc d'adresses IP principal)
variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Zones de disponibilité (AZ)
variable "availability_zones" {
  description = "Liste des zones de disponibilité"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]  # Adapter selon ta région
}

# CIDR des sous-réseaux publics
variable "public_subnet_cidrs" {
  description = "CIDR blocks pour les sous-réseaux publics"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
}

# CIDR des sous-réseaux privés
variable "private_subnet_cidrs" {
  description = "CIDR blocks pour les sous-réseaux privés"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

# Type d'instance EC2
variable "instance_type" {
  description = "Type d'instance EC2 pour le web server"
  type        = string
  default     = "t2.micro"  # Gratuit dans le free tier
}

# Configuration RDS
variable "db_instance_class" {
  description = "Classe d'instance pour RDS"
  type        = string
  default     = "db.t3.micro"  # Petit mais suffisant pour tester
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "myappdb"
}

variable "db_username" {
  description = "Nom d'utilisateur de la base de données"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true  # Important: masque le mot de passe dans les logs
  default     = "ChangeMeToSecurePassword123!"  # À CHANGER en production!
}

# Tags pour identifier les ressources
# Ce fichier déclare toutes les variables que nous utiliserons dans notre infrastructure

# Nom du projet (utilisé dans les tags/noms des SG)
variable "project_name" {
  description = "Nom du projet pour les tags"
  type        = string
  default     = "student-aws-architecture"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "sandbox"
}