data "aws_route53_zone" "hosted-zone" {
  name         = "stevejcliu.com"
  private_zone = false
}

resource "aws_route53_record" "golang-alb-record" {
  zone_id = data.aws_route53_zone.hosted-zone.zone_id
  name    = "web.stevejcliu.com"
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