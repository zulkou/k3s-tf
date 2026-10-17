variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to reach the Kubernetes API and SSH, e.g. 203.0.113.4/32"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name. Required: the install step connects over SSH."
}

variable "alert_email" {
  type = string
}

variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519"
}

variable "region" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t4g.small"
}

variable "arch" {
  type    = string
  default = "arm64"

  validation {
    condition     = contains(["arm64", "amd64"], var.arch)
    error_message = "arch must be arm64 or amd64."
  }
}