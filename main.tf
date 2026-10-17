terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      ManagedBy = "terraform"
      Project   = "k3s"
    }
  }
}

# 1. The machine (swap this module to change provider)
module "vm" {
  source      = "./modules/aws-vm"
  admin_cidr  = var.admin_cidr
  key_name    = var.key_name
  alert_email = var.alert_email

  instance_type = var.instance_type
  arch = var.arch

  # Ubuntu 24.04
  # ami_owner = "099720109477"
  # ami_name  = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-*-server-*"
  # ssh_user  = "ubuntu"

  # Debian 12 (the name includes the arch, so match it to var.arch)
  # ami_owner = "136693071363"
  # ami_name  = "debian-12-arm64-*"
  # ssh_user  = "admin"
}

# 2. The install script (provider-agnostic, creates no resources)
module "k3s" {
  source   = "./modules/k3s"
  tls_sans = [module.vm.public_ip]

  # Legacy free tier / 1 GB RAM:
  # low_memory = true
}

# 3. Runs the script on the machine over SSH
module "install" {
  source           = "./modules/k3s-ssh"
  host             = module.vm.public_ip
  user             = module.vm.ssh_user
  private_key_path = var.private_key_path
  script           = module.k3s.user_data
}