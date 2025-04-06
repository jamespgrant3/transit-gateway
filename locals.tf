locals {
  dns                  = "james.local"
  inbound_endpoint_ips = { for i in aws_route53_resolver_endpoint.destination_inbound.ip_address : i.ip => i.ip }
}
