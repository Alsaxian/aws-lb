resource "aws_subnet" "public_subnet" {
  for_each = local.backend_settings

  vpc_id                  = aws_vpc.xitry_vpc.id
  cidr_block              = each.value.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = each.value.availability_zone
  tags = {
    Name = "PublicSubnet-${each.key}"
  }
}

resource "aws_route_table_association" "asso_public_subnet" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_subnet" "private_subnet" {
  for_each = local.backend_settings

  vpc_id                  = aws_vpc.xitry_vpc.id
  cidr_block              = each.value.private_cidr_block
  map_public_ip_on_launch = false
  availability_zone       = each.value.availability_zone
  tags = {
    Name = "PrivateSubnet-${each.key}"
  }
}

