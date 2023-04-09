data "aws_route53_zone" "selected_zone" {
  name = var.hosted_zone_name
}

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

resource "aws_security_group" "allow_http" {
  name        = "HTTP Access from public subnet"
  description = "HTTP Access from public subnet"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS Public Traffic"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
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


resource "aws_instance" "webserver" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  user_data              = <<EOF
#!/usr/bin/env bash

# description : install httpd and generate a basic index.html

yum update -y

yum install -y httpd

systemctl start httpd

systemctl enable httpd

echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html

  EOF
  tags = {
    "Name" = "Web Server"
  }
}


resource "aws_route53_record" "web_server_dns_record" {
  zone_id = data.aws_route53_zone.selected_zone.id
  name    = "web.${data.aws_route53_zone.selected_zone.name}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.webserver.public_ip]
}