locals {
  server_args = concat(
    [for s in var.tls_sans : "--tls-san ${s}"],
    var.low_memory ? ["--disable metrics-server", "--disable traefik"] : [],
    var.extra_args,
  )

  swap_cmds = var.low_memory ? join("\n", [
    "fallocate -l 1G /swapfile",
    "chmod 600 /swapfile",
    "mkswap /swapfile",
    "swapon /swapfile",
    "echo '/swapfile none swap sw 0 0' >> /etc/fstab",
  ]) : ""

  script = <<-EOT
    #!/bin/bash
    set -euo pipefail
    ${local.swap_cmds}
    curl -sfL https://get.k3s.io | \
      INSTALL_K3S_VERSION="${var.k3s_version}" \
      sh -s - server ${join(" ", local.server_args)}
  EOT
}