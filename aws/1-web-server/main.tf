data "aws_vpc" "default" {
  default = true
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
  name        = "default-public-subnet-http"
  description = "Allow HTTP Traffic from anywhere"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description      = "Allow HTTP Traffic from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami             = data.aws_ami.amazon_linux_2.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.allow_http.id]
  
  root_block_device {
    volume_size = var.ebs_root_volume_size
    volume_type = var.ebs_volume_type
  }
  tags = {
    Name = "Web Server"
  }
  user_data = <<EOF
    #!/bin/env bash

    yum makecache
    
    yum install httpd

    echo "<h1>EC2 : Hello from $HOST</h1>" >> /var/www/html/index.html

    chown www:www /var/www/html/index.html

    service httpd enable

    service httpd start
  EOF
}