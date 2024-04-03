locals {
  backend_settings = {
    Affe = {
      public_cidr_block  = "10.0.1.0/24"
      private_cidr_block = "10.0.11.0/24"
      availability_zone  = "us-east-1b"
    },
    Apfel = {
      public_cidr_block  = "10.0.2.0/24"
      private_cidr_block = "10.0.12.0/24"
      availability_zone  = "us-east-1c"
    }
  }
}
