# backend.tf
terraform {
  backend "s3" {
    bucket         = "damian-andrzej9-statebucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
