locals {
  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
  private_subnets = {
    for i, s in var.private_vpc_subnet_cidrs : s => {
      az = local.azs[i]
    }
  }
  public_subnets = {
    for i, s in var.public_vpc_subnet_cidrs : s => {
      az = local.azs[i]
    }
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id

  for_each          = tomap(local.private_subnets)
  cidr_block        = each.key
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id

  for_each          = tomap(local.public_subnets)
  cidr_block        = each.key
  availability_zone = each.value.az

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  for_each = aws_subnet.private

  # route to nat gateway in public subnet
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }

  dynamic "route" {
    for_each = var.transit_gateway
    content {
      cidr_block         = route.value.cidr
      transit_gateway_id = route.value.transit_gateway_id
    }
  }

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  for_each = aws_subnet.public

  # route to internet gateway in public subnet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}
