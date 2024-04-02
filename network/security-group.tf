resource "aws_security_group" "private_sg" {

  vpc_id      = aws_vpc.xitry_vpc.id
  description = "dev security group"

  name = "private_sg"

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
  program = ["sh", "./get_public_ip.sh"]
}