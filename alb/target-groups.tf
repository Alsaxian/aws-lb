resource "aws_lb_target_group" "alb_tg" {
  for_each = module.network_module.backend_names
  
  name     = "${each.key}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network_module.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  for_each = module.network_module.backend_names

  target_group_arn = aws_lb_target_group.alb_tg[each.key].arn
  target_id        = module.network_module.instance_private_ec2_id[each.key]
  port             = 80
}