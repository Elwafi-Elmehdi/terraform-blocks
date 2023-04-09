output "dns_record" {
  value = aws_route53_record.web_server_dns_record.fqdn
}

output "server_ip" {
  value = aws_instance.webserver.public_ip
}