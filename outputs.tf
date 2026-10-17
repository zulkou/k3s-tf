output "public_ip" {
  value = module.vm.public_ip
}

output "ssm_session_cmd" {
  value = "aws ssm start-session --target ${module.vm.instance_id} --region ${var.region}"
}

output "kubeconfig_cmd" {
  value = "ssh -i ${var.private_key_path} ${module.vm.ssh_user}@${module.vm.public_ip} 'sudo cat /etc/rancher/k3s/k3s.yaml' | sed 's/127.0.0.1/${module.vm.public_ip}/' > kubeconfig"
}