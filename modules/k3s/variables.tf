variable "k3s_version" {
  type        = string
  default     = ""
  description = "Empty = latest from the stable channel. Pin it, e.g. v1.31.4+k3s1."
}

variable "tls_sans" {
  type    = list(string)
  default = []
}

variable "low_memory" {
  type        = bool
  default     = false
  description = "Adds a 1G swapfile and disables metrics-server and traefik."
}

variable "extra_args" {
  type    = list(string)
  default = []
}