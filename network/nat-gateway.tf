resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet["Affe"].id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.xitry_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each = aws_subnet.private_subnet

  subnet_id = each.value.id

  route_table_id = aws_route_table.private_route_table.id
}