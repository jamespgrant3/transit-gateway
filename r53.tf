# create hosted zone in destination
resource "aws_route53_zone" "primary" {
  name = local.dns

  vpc {
    vpc_id = module.destination_vpc.vpc_id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${local.dns}"
  type    = "A"
  ttl     = "30"
  records = ["192.168.7.77"]
}

resource "aws_route53_resolver_rule" "local_rule" {
  domain_name = local.dns
  name        = "james-local-rule"
  rule_type   = "FORWARD"

  # outbound resolver id
  resolver_endpoint_id = aws_route53_resolver_endpoint.source_outbound.id

  # target the inbound endpoint ips
  dynamic "target_ip" {
    for_each = local.inbound_endpoint_ips
    content {
      ip = target_ip.value
    }
  }
}

resource "aws_route53_resolver_rule_association" "local_rul_association" {
  resolver_rule_id = aws_route53_resolver_rule.local_rule.id
  vpc_id           = module.source_vpc.vpc_id
}
