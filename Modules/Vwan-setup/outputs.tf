output "firewall1_name" {
  value = azurerm_firewall.fw1.name
}

output "firewall2_name" {
  value = azurerm_firewall.fw2.name
}

output "firewall1_public_ip" {
  value = azurerm_public_ip.fw1_pip.ip_address
}

output "firewall2_public_ip" {
  value = azurerm_public_ip.fw2_pip.ip_address
}
