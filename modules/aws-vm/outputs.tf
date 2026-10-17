output "public_ip" {
  value = aws_eip_association.k3s.public_ip
}

output "instance_id" {
  value = aws_instance.k3s.id
}

output "ssh_user" {
  value = var.ssh_user
}