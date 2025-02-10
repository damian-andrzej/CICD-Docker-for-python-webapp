# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # Optional: Enable state locking using DynamoDB
    acl            = "bucket-owner-full-control"
  }
}
