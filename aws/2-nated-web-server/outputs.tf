output "public_ip" {
  value       = aws_eip.elastic_ip.address
  description = "the public elastic ip address of the nat gateway"
}
output "bastian_host_ip" {
  value       = aws_instance.bastian_server.public_ip
  description = "The public IP address of the bastian host"
}
output "bastian_private_ip" {
  value = aws_instance.bastian_server.private_ip
}