#!/usr/bin/env bash

# description : install httpd and generate a basic index.html

yum update -y

yum install -y httpd

systemctl start httpd

systemctl enable httpd

echo "<h1>Hello from $(hostanme -f)</h1>"

