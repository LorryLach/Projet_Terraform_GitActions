terraform {
  backend "s3" {
    bucket = "nom-de-ton-bucket-s3"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-3"
  }
}
