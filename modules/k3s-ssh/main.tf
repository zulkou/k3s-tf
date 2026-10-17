# Runs the install script on any machine you can SSH into:
# AWS, a VPS from another provider, or a box on your LAN.
resource "terraform_data" "install" {
  triggers_replace = [var.script, var.host, var.user]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.user
    private_key = file(var.private_key_path)
    timeout     = "5m"
  }

  provisioner "file" {
    content     = var.script
    destination = "/tmp/k3s-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait || true",
      "sudo bash /tmp/k3s-install.sh",
    ]
  }
}