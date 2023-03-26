output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "bastian_public_ip" {
  value = aws_instance.bastian_host.public_ip
}