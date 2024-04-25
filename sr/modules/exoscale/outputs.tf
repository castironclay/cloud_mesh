output "public_ip" {
  value = exoscale_compute_instance.my_instance.public_ip_address
}
