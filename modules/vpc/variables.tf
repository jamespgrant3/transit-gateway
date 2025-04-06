variable "vpc_cidr" {}
variable "vpc_name" {}
variable "private_vpc_subnet_cidrs" {}
variable "public_vpc_subnet_cidrs" {}
variable "transit_gateway" {
  type = list(object({
    cidr               = string
    transit_gateway_id = string
  }))
}
