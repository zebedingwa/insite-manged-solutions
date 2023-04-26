provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::171500075550:role/terraform-guru"
  }
  
}

terraform {
  backend "s3" {
  region = "us-east-1"
    
  }
}