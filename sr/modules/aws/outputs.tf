output "public_ip" {
  value = aws_lightsail_instance.instance.public_ip_address
}
