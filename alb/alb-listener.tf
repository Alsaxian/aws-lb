resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  for_each = module.network_module.backend_names

  listener_arn = aws_lb_listener.http_listener.arn
  priority     = local.listener_rule_priorities[each.key]

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg[each.key].arn
  }

  condition {
    path_pattern {
      values = ["/${each.key}*"]
    }
  }
}

