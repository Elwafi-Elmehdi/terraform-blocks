data "aws_vpc" "default" {
  default = true
}
resource "aws_key_pair" "public_key" {
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjjp0MyNr7d558xPzCmkqpvRMtBpKIvfU3Gf3ZS6xgg EC2 Public"
  key_name   = "terraform_key2"
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
    description = "Allow HTTP Traffic from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH Traffic from the internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description      = "Allow Internet Access"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = aws_key_pair.public_key.key_name
  root_block_device {
    volume_size = var.ebs_root_volume_size
    volume_type = var.ebs_volume_type
  }
  tags = {
    Name = "Web Server"
  }
  user_data = <<EOF
    #!/bin/bash

    yum update -y 
    if [[ $? -eq 0 ]]; then
      echo "update successfull" > /home/ec2-user/update.log
      chmod 700 /home/ec2-user/update.log 
    fi
    exit 0
  EOF
}