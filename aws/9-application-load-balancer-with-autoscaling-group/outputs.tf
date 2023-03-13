output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "instances_ip" {
  value = [for instance in aws_instance.web_servers : instance.private_ip]
}
output "bastian_public_ip" {
  value = aws_instance.bastian_host.public_ip
}