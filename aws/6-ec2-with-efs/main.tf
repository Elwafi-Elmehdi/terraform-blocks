###################
## VPC Resources
###################

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}
###################
## Subnet Resouces
###################

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = count.index % 2 == 0 ? "${var.default_region }a" : "${var.default_region}b"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = count.index % 2 == 0 ? "${var.default_region }a" : "${var.default_region}b"
}

resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}