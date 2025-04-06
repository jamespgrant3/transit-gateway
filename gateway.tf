resource "aws_ec2_transit_gateway" "this" {
  description                     = "example"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
}

# create the source route table
resource "aws_ec2_transit_gateway_route_table" "source" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "source"
  }
}

# create the destination route table
resource "aws_ec2_transit_gateway_route_table" "destination" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  tags = {
    Name = "destination"
  }
}

# attach the source vpc to the transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "source" {
  subnet_ids = [
    module.source_vpc.private_1a_subnet_id,
    module.source_vpc.private_1b_subnet_id,
    module.source_vpc.private_1c_subnet_id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.source_vpc.vpc_id
  tags = {
    Name = "source"
  }
}

# attach the destination vpc to the transit gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "destination" {
  subnet_ids = [
    module.destination_vpc.private_1a_subnet_id,
    module.destination_vpc.private_1b_subnet_id,
    module.destination_vpc.private_1c_subnet_id
  ]
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = module.destination_vpc.vpc_id
  tags = {
    Name = "destination"
  }
}

# associate the route table to the attachment
resource "aws_ec2_transit_gateway_route_table_association" "source" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.source.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.source.id
}

# associate the route table to the attachment
resource "aws_ec2_transit_gateway_route_table_association" "destination" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.destination.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.destination.id
}

# route traffic destined for the destination vpc to the destination attachment
resource "aws_ec2_transit_gateway_route" "source_to_destination" {
  destination_cidr_block         = module.destination_vpc.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.destination.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.source.id
}

# route traffic destined for the source vpc to the source attachment
resource "aws_ec2_transit_gateway_route" "destination_to_source" {
  destination_cidr_block         = module.source_vpc.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.source.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.destination.id
}
