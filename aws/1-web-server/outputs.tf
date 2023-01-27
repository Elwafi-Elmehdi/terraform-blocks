output "public_ip" {
  value = aws_instance.web.public_ip
}
output "url" {
  value = "http://${aws_instance.web.public_ip}/"
}