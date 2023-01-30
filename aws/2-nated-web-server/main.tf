#############################
## VPC Resources
#############################

resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "Default VPC"
  }
}
resource "aws_default_subnet" "default_public_subnet" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_eip" "elastic_ip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_default_subnet.default_public_subnet.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_default_vpc.default_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_default_vpc.default_vpc.id
  cidr_block = "172.31.48.0/20"
  tags = {
    "Name" = "Private Subnet"
  }
}

resource "aws_route_table_association" "table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
#############################
## EC2 Security Groups 
#############################

resource "aws_security_group" "bastian_sg" {
  name        = "Web Server Security Group"
  description = "Allow Public Access for HTTP and SSH from public subnet only"
  ingress {
    description      = "SSH from Internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_security_group" "web_server_sg" {
  name        = "Bastin SSH public access"
  description = "Allow Public Access for SSH"
  ingress {
    description      = "HTTP from Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "SSH from Public SUbnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastian_server.private_ip}/32"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

#############################
## EC2 Resources
#############################


data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_key_pair" "public_key" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjjp0MyNr7d558xPzCmkqpvRMtBpKIvfU3Gf3ZS6xgg EC2 Public"
  key_name   = "terraform_key"
}

resource "aws_instance" "bastian_server" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.public_key.key_name
  subnet_id       = aws_default_subnet.default_public_subnet.id
  security_groups = [aws_security_group.bastian_sg.id]
  tags = {
    "Name" = "Bastian Server"
  }
}

resource "aws_instance" "web_server" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.public_key.key_name
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.web_server_sg]
}