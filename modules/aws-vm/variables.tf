variable "name" {
  type    = string
  default = "k3s"
}

# New (post Jul 2025) accounts: t4g.small is free-tier eligible.
# Legacy accounts: "t3.micro" with arch = "amd64".
variable "instance_type" {
  type    = string
  default = "t4g.small"
}

# "arm64" for t4g/m7g/c7g, "amd64" for t3/t2
variable "arch" {
  type    = string
  default = "arm64"

  validation {
    condition     = contains(["arm64", "amd64"], var.arch)
    error_message = "arch must be arm64 or amd64."
  }
  validation {
    condition     = can(regex("^[a-z][0-9]+g[a-z]*\\.", var.instance_type)) == (var.arch == "arm64")
    error_message = "arch must match instance_type: *g families (t4g, c7g, m7g, c6gn) are arm64; t3/m5/t2 etc. are amd64."
  }
}

# Who publishes the image: an AWS account ID, or "amazon" / "self".
variable "ami_owner" {
  type    = string
  default = "amazon"
}

# Image name pattern; * matches anything. The newest match wins.
variable "ami_name" {
  type    = string
  default = "al2023-ami-2023.*"
}

# Login user of that image.
variable "ssh_user" {
  type    = string
  default = "ec2-user"
}

# Spot is not covered by the free tier.
variable "use_spot" {
  type    = bool
  default = false
}

variable "admin_cidr" {
  type = string
}

# If null, no SSH rule is created (use SSM Session Manager instead).
variable "key_name" {
  type    = string
  default = null
}

# Free tier covers up to 30 GB of EBS.
variable "root_volume_gb" {
  type    = number
  default = 20
}

# Optional cloud-init script. Leave empty to install k3s separately over SSH.
variable "user_data" {
  type    = string
  default = ""
}

variable "alert_email" {
  type = string
}

variable "budget_usd" {
  type    = string
  default = "5"
}