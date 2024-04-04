resource "aws_instance" "bastion_host" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_auth.key_name
  associate_public_ip_address = true

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.006"
    }
  }

  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]

  subnet_id = aws_subnet.public_subnet["Affe"].id

  root_block_device {
    volume_size = 8 # must be greater or equal to 8 GB
  }

#   user_data = file("templates/userdata.tpl")

  tags = {
    Name = "BastionHost"
  }

#   depends_on = [ aws_route_table_association.private_route_table_association ]
}

resource "aws_security_group" "bastion_host_sg" {

  vpc_id      = aws_vpc.xitry_vpc.id
  description = "bastion host security group"

  name = "bastion_host_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.get_public_ip.result.public_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

data "external" "get_public_ip" {
  program = ["sh", "templates/get_public_ip.sh"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_bastion_host" {
  security_group_id = aws_security_group.private_sg.id
  description = "Allow inbound traffic from bastion host onto the private security group"

  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.bastion_host_sg.id
}

resource "aws_eip" "bastion_host" {
  instance = aws_instance.bastion_host.id
  domain = "vpc"
}