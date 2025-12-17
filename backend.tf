terraform {
  backend "s3" {
    bucket         = "terraform-state-lorrylach-2025v2"  
    key            = "project/terraform.tfstate"
    region         = "us-east-1" 
    encrypt        = true
  }
}