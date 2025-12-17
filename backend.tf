terraform {
  backend "s3" {
    bucket         = "terraform-state-lorrylach-2025"  
    key            = "project/terraform.tfstate"
    region         = "us-east-1" 
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}