module "vwan_setup" {
  source      = "./modules/vwan-setup"
  location    = var.location
  env         = var.env
  vnet1_cidr  = var.vnet1_cidr
  vnet2_cidr  = var.vnet2_cidr
}

output "firewall1_public_ip" {
  value = module.vwan_setup.firewall1_public_ip
}

output "firewall2_public_ip" {
  value = module.vwan_setup.firewall2_public_ip
}