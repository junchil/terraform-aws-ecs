resource "aws_alb" "golang-alb" {
  name            = "golang-load-balancer"
  subnets         = var.public_subnet
  security_groups = [aws_security_group.aws-golang-alb.id]
  tags = {
    Name = "golang-app-alb"
  }
}

resource "aws_security_group" "aws-golang-alb" {
  name        = "golang-load-balancer-sg"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "golang-load-balancer"
  }
}

resource "aws_alb_target_group" "golang_app" {
  name        = "golang-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "2"
    interval            = "20"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "3"
  }
  tags = {
    Name = "golang-alb-target-group"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "alb-https-listener" {
  load_balancer_arn = aws_alb.golang-alb.id
  port              = 443
  protocol          = "HTTPS"

  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    target_group_arn = aws_alb_target_group.golang_app.id
    type             = "forward"
  }
}

resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_alb.golang-alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_route53_zone" "hosted-zone" {
  name         = "stevejcliu.com"
  private_zone = false
}

resource "aws_route53_record" "golang-alb-record" {
  zone_id = data.aws_route53_zone.hosted-zone.zone_id
  name    = "stevejcliu.com"
  type    = "A"

  alias {
    name                   = aws_alb.golang-alb.dns_name
    zone_id                = aws_alb.golang-alb.zone_id
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