variable "aws_region" {
  description = "Région AWS pour le déploiement"
  type        = string
  default     = "us-east-1"  
}


variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
  default     = "10.0.0.0/16"
}


variable "availability_zones" {
  description = "Liste des zones de disponibilité"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] 
}


variable "public_subnet_cidrs" {
  description = "CIDR blocks pour les sous-réseaux publics"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
}


variable "private_subnet_cidrs" {
  description = "CIDR blocks pour les sous-réseaux privés"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}


variable "instance_type" {
  description = "Type d'instance EC2 pour le web server"
  type        = string
  default     = "t2.micro"  
}


variable "db_instance_class" {
  description = "Classe d'instance pour RDS"
  type        = string
  default     = "db.t3.micro"  
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
  sensitive   = true  
  default     = "ChangeMeToSecurePassword123!"  
}


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