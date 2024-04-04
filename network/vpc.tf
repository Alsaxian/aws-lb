resource "aws_vpc" "xitry_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "lb-VPC"
  }
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}



resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.xitry_vpc.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.xitry_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}


