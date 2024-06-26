data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ec2_auth" {
  key_name   = "xitry_auth"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "bakend_ec2" {
  for_each = local.backend_settings

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_auth.key_name
  associate_public_ip_address = false

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.006"
    }
  }

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  subnet_id = aws_subnet.private_subnet[each.key].id

  root_block_device {
    volume_size = 8 # must be greater or equal to 8 GB
  }

  user_data = file(var.user_data_path)

  tags = {
    Name = "BackendEC2-${each.key}"
  }

  depends_on = [ aws_route_table_association.private_route_table_association ]
}