terraform {
  backend "s3" {
    bucket = "xitry-terraform-state"
    key    = "aws-lb/nlb/terraform.tfstate"
    region = "us-east-1"
  }
}