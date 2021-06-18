resource "aws_security_group" "aws-lb" {
  name        = "nginx-load-balancer-sg"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["10.0.228.0/22", "10.0.232.0/22", "10.0.236.0/22"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "nginx-load-balancer"
  }
}

resource "aws_alb" "main" {
  name            = "nginx-load-balancer"
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.aws-lb.id]
  tags = {
    Name = "nginx-app-alb"
  }
}

resource "aws_alb_target_group" "nginx_app" {
  name        = "nginx-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
  tags = {
    Name = "nginx-alb-target-group"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.nginx_app.id
    type             = "forward"
  }
}

data "aws_route53_zone" "hosted-zone" {
    name = "stevejcliu.com"
    private_zone = false
}

resource "aws_route53_record" "nginx-alb-record" {
  zone_id = data.aws_route53_zone.hosted-zone.zone_id
  name    = "web.stevejcliu.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.main.dns_name}"
    zone_id                = "${aws_alb.main.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert" {
  // has to be a wildcard all of the subdomains should be certified
  domain_name       = "*.stevejcliu.com"
  validation_method = "DNS"

  tags = {
    Name = var.cluster_name
  }

  lifecycle {
    create_before_destroy = true
  }
}