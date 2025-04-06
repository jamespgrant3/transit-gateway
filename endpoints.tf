resource "aws_route53_resolver_endpoint" "source_outbound" {
  name                   = "source-outbound"
  direction              = "OUTBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [
    aws_security_group.source_vpc_outbound_endpoint.id
  ]

  ip_address {
    subnet_id = module.source_vpc.private_1a_subnet_id
  }

  ip_address {
    subnet_id = module.source_vpc.private_1b_subnet_id
  }

  ip_address {
    subnet_id = module.source_vpc.private_1c_subnet_id
  }

  protocols = ["Do53"]

  tags = {
    Name = "source-outbound"
  }
}

resource "aws_route53_resolver_endpoint" "destination_inbound" {
  name                   = "destination-inbound"
  direction              = "INBOUND"
  resolver_endpoint_type = "IPV4"

  security_group_ids = [
    aws_security_group.destination_vpc_inbound_endpoint.id
  ]

  ip_address {
    subnet_id = module.destination_vpc.private_1a_subnet_id
  }

  ip_address {
    subnet_id = module.destination_vpc.private_1b_subnet_id
  }

  ip_address {
    subnet_id = module.destination_vpc.private_1c_subnet_id
  }

  protocols = ["Do53"]

  tags = {
    Name = "destination_inbound"
  }
}
