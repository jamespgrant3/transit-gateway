# source vpc's outbound endpoint is going to have to allow egress dns queries to the destination
resource "aws_security_group" "source_vpc_outbound_endpoint" {
  name   = "source-outbound-endpoint"
  vpc_id = module.source_vpc.vpc_id

  tags = {
    Name = "source-outbound-endpoint"
  }
}

resource "aws_vpc_security_group_egress_rule" "egress_tcp_53" {
  security_group_id = aws_security_group.source_vpc_outbound_endpoint.id

  cidr_ipv4   = module.destination_vpc.vpc_cidr
  from_port   = 53
  ip_protocol = "tcp"
  to_port     = 53
}

resource "aws_vpc_security_group_egress_rule" "egress_udp_53" {
  security_group_id = aws_security_group.source_vpc_outbound_endpoint.id

  cidr_ipv4   = module.destination_vpc.vpc_cidr
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}

# destination vpc's inbound endpoint is going to have to allow ingress dns queries from the source
resource "aws_security_group" "destination_vpc_inbound_endpoint" {
  name   = "destination-inbound-endpoint"
  vpc_id = module.destination_vpc.vpc_id

  tags = {
    Name = "destination-inbound-endpoint"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_tcp_53" {
  security_group_id = aws_security_group.destination_vpc_inbound_endpoint.id

  cidr_ipv4   = module.source_vpc.vpc_cidr
  from_port   = 53
  ip_protocol = "tcp"
  to_port     = 53
}

resource "aws_vpc_security_group_ingress_rule" "ingress_udp_53" {
  security_group_id = aws_security_group.destination_vpc_inbound_endpoint.id

  cidr_ipv4   = module.source_vpc.vpc_cidr
  from_port   = 53
  ip_protocol = "udp"
  to_port     = 53
}
