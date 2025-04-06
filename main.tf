module "source_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "12.0.0.0/16"
  vpc_name = "source"
  private_vpc_subnet_cidrs = [
    "12.0.0.0/20",
    "12.0.16.0/20",
    "12.0.32.0/20"
  ]
  public_vpc_subnet_cidrs = [
    "12.0.48.0/20",
    "12.0.64.0/20",
    "12.0.80.0/20"
  ]
  transit_gateway = [{
    cidr               = module.destination_vpc.vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }]
}

module "destination_vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "13.0.0.0/16"
  vpc_name = "destination"
  private_vpc_subnet_cidrs = [
    "13.0.0.0/20",
    "13.0.16.0/20",
    "13.0.32.0/20"
  ]
  public_vpc_subnet_cidrs = [
    "13.0.48.0/20",
    "13.0.64.0/20",
    "13.0.80.0/20"
  ]
  transit_gateway = [{
    cidr               = module.source_vpc.vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.this.id
  }]
}
