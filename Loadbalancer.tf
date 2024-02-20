
# Create the Application Load Balancer

resource "aws_lb" "observability_alb" {
  name               = "${var.observability_server}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnit_id_A, var.public_subnit_id_B, var.public_subnit_id_C]
  security_groups    = [aws_security_group.alb_observability_server_sg.id]
  tags = {
    Name = "${var.observability_server}-alb"
    Environment = "Prod"
  }
}

# Create the HTTPS listener

resource "aws_lb_listener" "https_listener-observability" {
   load_balancer_arn = aws_lb.observability_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Grafana_target_group.arn
  }
  tags = {
    Name        = "${var.observability_server}-https_listener"
    Environment = "var."
  }
}

# Create the HTTP listener and forward to HTTPS listener

resource "aws_lb_listener" "http_listener-observability" {
  load_balancer_arn = aws_lb.observability_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Grafana_target_group.arn
  }
  tags = {
    Name        = "${var.observability_server}-https_listener"
    Environment = "Prod"
  }
}

resource "aws_lb_listener" "http_listener-observability-P9s" {
  load_balancer_arn = aws_lb.observability_alb.arn
  port              = 9090
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Promethious_target_group.arn
  }
  tags = {
    Name        = "${var.observability_server}-https_listener"
    Environment = "Prod"
  }
}

# Create the Target Group(need to re-work on this)

resource "aws_lb_target_group" "Promethious_target_group" {
  name     = "${var.observability_server}-P9s-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "9090"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200,302"
  }
tags = {
    Name = "${var.observability_server}-tg"
    Environment = "Prod"
  }
}

resource "aws_lb_target_group" "Grafana_target_group" {
  name     = "${var.observability_server}-G5a-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "3000"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200,302"
  }
tags = {
    Name = "${var.observability_server}-tg"
    Environment = "Prod"
  }
}

############################### Output DNS name of the ALB ##############################################################
output "Grafana_dashboard_link" {
  value = aws_lb.observability_alb.dns_name
}