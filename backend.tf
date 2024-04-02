terraform {
  backend "s3" {
    bucket = "xitry-terraform-state"
    key    = "aws-lb/terraform.tfstate"
    region = "us-east-1"
  }
}