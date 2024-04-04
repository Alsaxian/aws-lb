resource "aws_lb" "demo_alb" {
  name               = "demo-alb"
  load_balancer_type = "application"
  subnets            = values(module.network_module.public_subnet_id)
  enable_cross_zone_load_balancing = true
}


resource "aws_lb_target_group" "tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = module.network_module.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.demo_nlb.arn
  protocol          = "TCP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group_attachment" "apfel" {
  for_each = module.network_module.instance_private_ec2_id

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb" {
  security_group_id = module.network_module.private_sg_id
  description = "Allow inbound traffic from my ip onto the private security group"

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "${module.network_module.my_ip}/32"
}