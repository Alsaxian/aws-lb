resource "aws_lb" "demo_alb" {
  name               = "demo-alb"
  load_balancer_type = "application"
  subnets            = values(module.network_module.public_subnet_id)
  security_groups    = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow web traffic to ALB"
  vpc_id      = module.network_module.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${module.network_module.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## This no need.

# resource "aws_vpc_security_group_ingress_rule" "allow_my_ip" {
#   security_group_id = module.network_module.private_sg_id
#   description = "Allow inbound traffic from my ip onto the private security group"

#   from_port   = 80
#   to_port     = 80
#   ip_protocol = "tcp"
#   cidr_ipv4   = "${module.network_module.my_ip}/32"
# }

resource "aws_vpc_security_group_ingress_rule" "allow_alb" {
  security_group_id = module.network_module.private_sg_id
  description = "Allow inbound traffic from my ip onto the private security group"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.alb_sg.id
}