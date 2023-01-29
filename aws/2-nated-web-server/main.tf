resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_subnet" "default_public_subnet" {
  availability_zone = "${var.aws_region}-a"
}
resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_default_vpc.default_vpc.id
}

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic_ip.id 
}

resource "aws_route_table" "private_route_table" {
  
}
