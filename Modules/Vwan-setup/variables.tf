variable "location" {
  type        = string
  description = "Primary Azure region"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "vnet1_cidr" {
  type        = string
  description = "CIDR block for VNet 1"
}

variable "vnet2_cidr" {
  type        = string
  description = "CIDR block for VNet 2"
}
