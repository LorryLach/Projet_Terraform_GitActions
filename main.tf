# main.tf
# Fichier principal: configuration du provider et création du VPC

# Configuration du provider AWS
terraform {
  required_version = ">= 1.0"  # Version minimum de Terraform requise
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Utilise la version 5.x la plus récente
    }
  }
}

# Provider AWS - indique où et comment se connecter à AWS
provider "aws" {
  region = var.aws_region
  
  # Tags par défaut appliqués à toutes les ressources
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Student     = "true"
    }
  }
}

# VPC (Virtual Private Cloud) - Notre réseau privé dans AWS
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true  # Active les noms DNS pour les instances
  enable_dns_support   = true  # Active la résolution DNS
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway - Permet au VPC de communiquer avec Internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.project_name}-igw"
  }
}