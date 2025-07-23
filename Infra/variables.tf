variable "location" {
  description = "Azure region for primary hub"
  type        = string
}

variable "env" {
  description = "Environment (dev/test/prod)"
  type        = string
}

variable "vnet1_cidr" {
  description = "CIDR block for VNet 1"
  type        = string
}

variable "vnet2_cidr" {
  description = "CIDR block for VNet 2"
  type        = string
}