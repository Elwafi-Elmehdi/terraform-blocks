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
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = count.index % 2 == 0 ? "${var.default_region}a" : "${var.default_region}b"
  map_public_ip_on_launch = true
}
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = count.index % 2 == 0 ? "${var.default_region}a" : "${var.default_region}b"
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

###################
## Security Groups
###################
resource "aws_security_group" "allow_alb_http" {
  name        = "HTTP Public Access to ALB"
  description = "Allow HTTP Traffic from anywhere"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow HTPP Traffic from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description      = "Allow Egress Internet Access"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
resource "aws_security_group" "allow_instance_http_ssh" {
  name        = "HTTP Access for Instances "
  description = "Allow HTTP Traffic from anywhere"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH Traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description      = "Allow Egress Internet Access"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

###################
## EC2 Reosurces
###################

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

resource "aws_key_pair" "terraform_key_pair" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjjp0MyNr7d558xPzCmkqpvRMtBpKIvfU3Gf3ZS6xgg EC2"
  key_name   = "Terraform_Key_Pair"
}

resource "aws_instance" "web_servers" {
  count                  = length(var.public_subnets_cidr)
  key_name               = aws_key_pair.terraform_key_pair.key_name
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet[count.index].id
  vpc_security_group_ids = [aws_security_group.allow_instance_http_ssh.id]
  user_data              = file("./data/boostrap.sh")
  tags = {
    "Name" = "Server ${count.index}"
  }
}

###################
## ALB resources
###################

resource "aws_lb" "alb" {

  name               = "demo-terraform-alb"
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_alb_http.id]
}

resource "aws_lb_target_group" "alb_target_group" {
  name     = "demo-terraform-tg"
  vpc_id   = aws_vpc.vpc.id
  port     = "80"
  protocol = "HTTP"
}
resource "aws_lb_target_group_attachment" "lb_target_group_attachments" {
  count            = length(var.public_subnets_cidr)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.web_servers[count.index].id
  port             = 80
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_target_group.arn
    type             = "forward"
  }
}