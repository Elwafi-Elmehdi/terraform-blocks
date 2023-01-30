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
  subnet_id = aws_default_subnet.default_public_subnet.id
  depends_on = [
    aws_internet_gateway.default_igw
  ]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_default_vpc.default_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table_association" "table_association" {
  subnet_id = aws_default_subnet.default_public_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "bastian_sg" {
  name = "Web Server Security Group"
  description = "Allow Public Access for HTTP and SSH from public subnet only"
  ingress {
    description = "SSH from Internet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
}
resource "aws_security_group" "web_server_sg" {
  name = "Bastin SSH public access"
  description = "Allow Public Access for SSH"
  ingress {
    description = "HTTP from Internet"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
  }
  ingress {
    description = "SSH from Public SUbnet"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${aws_default_subnet.default_public_subnet.cidr_block}" ]
  }
}
