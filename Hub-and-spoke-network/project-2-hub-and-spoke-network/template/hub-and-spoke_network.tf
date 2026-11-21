terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.80.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-1" {
  location = "eastus"
  name     = "Project_2"
}
resource "azurerm_windows_virtual_machine" "res-1" {
  admin_username                    = "azureuser"
  allow_extension_operations        = true
  automatic_updates_enabled         = true
  computer_name                     = "vm-NVA"
  disk_controller_type              = "NVMe"
  enable_automatic_updates          = true
  location                          = "eastus"
  name                              = "vm-NVA"
  network_interface_ids             = [azurerm_network_interface.res-1.id]
  os_managed_disk_id                = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/PROJECT_2/providers/Microsoft.Compute/disks/vm-NVA_OsDisk_1_c8d7938034c949e2a2abd4638ab214ce"
  patch_assessment_mode             = "ImageDefault"
  patch_mode                        = "AutomaticByOS"
  provision_vm_agent                = true
  resource_group_name               = azurerm_resource_group.res-1.name
  size                              = "Standard_F1als_v7"
  vm_agent_platform_updates_enabled = true
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 127
    name                 = "vm-NVA_OsDisk_1_c8d7938034c949e2a2abd4638ab214ce"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "res-2" {
  admin_username                    = "azureuser"
  allow_extension_operations        = true
  automatic_updates_enabled         = true
  computer_name                     = "vm-office"
  disk_controller_type              = "NVMe"
  enable_automatic_updates          = true
  location                          = "eastus"
  name                              = "vm-office"
  network_interface_ids             = [azurerm_network_interface.res-2.id]
  os_managed_disk_id                = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/PROJECT_2/providers/Microsoft.Compute/disks/vm-office_OsDisk_1_969ff1dafe744f28a84245bdd15c3ce1"
  patch_assessment_mode             = "ImageDefault"
  patch_mode                        = "AutomaticByOS"
  provision_vm_agent                = true
  resource_group_name               = azurerm_resource_group.res-1.name
  secure_boot_enabled               = true
  size                              = "Standard_F1als_v7"
  vm_agent_platform_updates_enabled = true
  vtpm_enabled                      = true
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 127
    name                 = "vm-office_OsDisk_1_969ff1dafe744f28a84245bdd15c3ce1"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "res-3" {
  admin_username                    = "azureuser"
  allow_extension_operations        = true
  automatic_updates_enabled         = true
  computer_name                     = "vm-plantA-OT"
  disk_controller_type              = "NVMe"
  enable_automatic_updates          = true
  location                          = "eastus"
  name                              = "vm-plantA-OT"
  network_interface_ids             = [azurerm_network_interface.res-3.id]
  os_managed_disk_id                = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Compute/disks/vm-plantA-OT_OsDisk_1_a2120fd5142348b3b0ece319bff314d9"
  patch_assessment_mode             = "ImageDefault"
  patch_mode                        = "AutomaticByOS"
  provision_vm_agent                = true
  resource_group_name               = azurerm_resource_group.res-1.name
  secure_boot_enabled               = true
  size                              = "Standard_F1als_v7"
  vm_agent_platform_updates_enabled = true
  vtpm_enabled                      = true
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 127
    name                 = "vm-plantA-OT_OsDisk_1_a2120fd5142348b3b0ece319bff314d9"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "res-4" {
  admin_username                    = "azureuser"
  allow_extension_operations        = true
  automatic_updates_enabled         = true
  computer_name                     = "vm-plantA-serve"
  disk_controller_type              = "NVMe"
  enable_automatic_updates          = true
  location                          = "eastus"
  name                              = "vm-plantA-server"
  network_interface_ids             = [azurerm_network_interface.res-4.id]
  os_managed_disk_id                = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Compute/disks/vm-plantA-server_OsDisk_1_e746c76c504e4c009943accc0018b2d4"
  patch_assessment_mode             = "ImageDefault"
  patch_mode                        = "AutomaticByOS"
  provision_vm_agent                = true
  resource_group_name               = azurerm_resource_group.res-1.name
  secure_boot_enabled               = true
  size                              = "Standard_F1als_v7"
  vm_agent_platform_updates_enabled = true
  vtpm_enabled                      = true
  zone                              = "1"
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 127
    name                 = "vm-plantA-server_OsDisk_1_e746c76c504e4c009943accc0018b2d4"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "res-5" {
  admin_username                    = "azureuser"
  allow_extension_operations        = true
  automatic_updates_enabled         = true
  computer_name                     = "vm-plantB-serve"
  disk_controller_type              = "NVMe"
  enable_automatic_updates          = true
  location                          = "eastus"
  name                              = "vm-plantB-server"
  network_interface_ids             = [azurerm_network_interface.res-5.id]
  os_managed_disk_id                = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Compute/disks/vm-plantB-server_OsDisk_1_ca02f8fdd2f444de918962eb60e549a0"
  patch_assessment_mode             = "ImageDefault"
  patch_mode                        = "AutomaticByOS"
  provision_vm_agent                = true
  resource_group_name               = azurerm_resource_group.res-1.name
  secure_boot_enabled               = true
  size                              = "Standard_F1als_v7"
  vm_agent_platform_updates_enabled = true
  vtpm_enabled                      = true
  additional_capabilities {
  }
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = 127
    name                 = "vm-plantB-server_OsDisk_1_ca02f8fdd2f444de918962eb60e549a0"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2025-datacenter-g2"
    version   = "latest"
  }
}
resource "azurerm_firewall" "res-1" {
  firewall_policy_id  = azurerm_firewall_policy.res-1.id
  location            = "eastus"
  name                = "fw-hub"
  resource_group_name = azurerm_resource_group.res-1.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  threat_intel_mode   = "Alert"
  ip_configuration {
    name                 = "pip-fw-hub"
    public_ip_address_id = azurerm_public_ip.res-4.id
    subnet_id            = azurerm_subnet.res-2.id
  }
}
resource "azurerm_firewall_policy" "res-1" {
  location            = "eastus"
  name                = "fwp-hub"
  resource_group_name = azurerm_resource_group.res-1.name
}
resource "azurerm_firewall_policy_rule_collection_group" "res-1" {
  firewall_policy_id = azurerm_firewall_policy.res-1.id
  name               = "DefaultNetworkRuleCollectionGroup"
  priority           = 200
  network_rule_collection {
    action   = "Allow"
    name     = "plants-out"
    priority = 100
    rule {
      destination_addresses = ["*"]
      destination_ports     = ["443"]
      name                  = "allow-https-out"
      protocols             = ["TCP"]
      source_addresses      = ["172.16.1.0/24", "192.168.1.0/24"]
    }
  }
}
resource "azurerm_network_interface" "res-1" {
  accelerated_networking_enabled = true
  ip_forwarding_enabled          = true
  location                       = "eastus"
  name                           = "vm-nva624"
  resource_group_name            = azurerm_resource_group.res-1.name
  ip_configuration {
    name                          = "ipconfig1"
    primary                       = true
    private_ip_address            = "10.0.0.4"
    private_ip_address_allocation = "Static"
    subnet_id                     = azurerm_subnet.res-4.id
  }
}
resource "azurerm_network_interface" "res-2" {
  accelerated_networking_enabled = true
  location                       = "eastus"
  name                           = "vm-office475"
  resource_group_name            = azurerm_resource_group.res-1.name
  ip_configuration {
    name                          = "ipconfig1"
    primary                       = true
    private_ip_address            = "10.5.2.4"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.res-6.id
  }
}
resource "azurerm_network_interface" "res-3" {
  accelerated_networking_enabled = true
  location                       = "eastus"
  name                           = "vm-planta-ot942"
  resource_group_name            = azurerm_resource_group.res-1.name
  ip_configuration {
    name                          = "ipconfig1"
    primary                       = true
    private_ip_address            = "172.16.2.4"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_A_Vnet/subnets/snet-OT"
  }
  depends_on = [
    # One of azurerm_subnet.res-7,azurerm_subnet_network_security_group_association.res-1,azurerm_subnet_route_table_association.res-1 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_interface" "res-4" {
  accelerated_networking_enabled = true
  location                       = "eastus"
  name                           = "vm-planta-server35"
  resource_group_name            = azurerm_resource_group.res-1.name
  ip_configuration {
    name                          = "ipconfig1"
    primary                       = true
    private_ip_address            = "172.16.1.4"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_A_Vnet/subnets/snet-Server"
  }
  depends_on = [
    # One of azurerm_subnet.res-8,azurerm_subnet_route_table_association.res-2 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_interface" "res-5" {
  accelerated_networking_enabled = true
  location                       = "eastus"
  name                           = "vm-plantb-server695"
  resource_group_name            = azurerm_resource_group.res-1.name
  ip_configuration {
    name                          = "ipconfig1"
    primary                       = true
    private_ip_address            = "192.168.1.4"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_B_Vnet/subnets/snet-Server"
  }
  depends_on = [
    # One of azurerm_subnet.res-10,azurerm_subnet_route_table_association.res-4 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_network_security_group" "res-1" {
  location            = "eastus"
  name                = "nsg-OT"
  resource_group_name = azurerm_resource_group.res-1.name
  security_rule = [{
    access                                     = "Deny"
    description                                = ""
    destination_address_prefix                 = "Internet"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "*"
    destination_port_ranges                    = []
    direction                                  = "Outbound"
    name                                       = "Deny-Internet-Out"
    priority                                   = 2000
    protocol                                   = "*"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]
}
resource "azurerm_network_security_rule" "res-1" {
  access                      = "Deny"
  destination_address_prefix  = "Internet"
  destination_port_range      = "*"
  direction                   = "Outbound"
  name                        = "Deny-Internet-Out"
  network_security_group_name = "nsg-OT"
  priority                    = 2000
  protocol                    = "*"
  resource_group_name         = azurerm_resource_group.res-1.name
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}
resource "azurerm_private_dns_zone" "res-1" {
  name                = "internal.dns"
  resource_group_name = azurerm_resource_group.res-1.name
  soa_record {
    email = "azureprivatedns-host.microsoft.com"
  }
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-1" {
  name                  = "hub-link"
  private_dns_zone_name = "internal.dns"
  registration_enabled  = true
  resource_group_name   = azurerm_resource_group.res-1.name
  virtual_network_id    = azurerm_virtual_network.res-1.id
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-2" {
  name                  = "office-link"
  private_dns_zone_name = "internal.dns"
  registration_enabled  = true
  resource_group_name   = azurerm_resource_group.res-1.name
  virtual_network_id    = azurerm_virtual_network.res-2.id
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-3" {
  name                  = "plantA-link"
  private_dns_zone_name = "internal.dns"
  registration_enabled  = true
  resource_group_name   = azurerm_resource_group.res-1.name
  virtual_network_id    = azurerm_virtual_network.res-3.id
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-4" {
  name                  = "plantB-link"
  private_dns_zone_name = "internal.dns"
  registration_enabled  = true
  resource_group_name   = azurerm_resource_group.res-1.name
  virtual_network_id    = azurerm_virtual_network.res-4.id
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_public_ip" "res-1" {
  allocation_method   = "Static"
  location            = "eastus"
  name                = "ip-vpn"
  resource_group_name = azurerm_resource_group.res-1.name
  zones               = ["1", "2", "3"]
}
resource "azurerm_public_ip" "res-2" {
  allocation_method   = "Static"
  location            = "eastus"
  name                = "pip-Hub-vpnip"
  resource_group_name = azurerm_resource_group.res-1.name
  zones               = ["1", "2", "3"]
}
resource "azurerm_public_ip" "res-3" {
  allocation_method   = "Static"
  location            = "eastus"
  name                = "pip-VPNoffice"
  resource_group_name = azurerm_resource_group.res-1.name
  zones               = ["1", "2", "3"]
}
resource "azurerm_public_ip" "res-4" {
  allocation_method   = "Static"
  location            = "eastus"
  name                = "pip-fw-hub"
  resource_group_name = azurerm_resource_group.res-1.name
}
resource "azurerm_route_table" "res-1" {
  location            = "eastus"
  name                = "rt-plantA"
  resource_group_name = azurerm_resource_group.res-1.name
  route = [{
    address_prefix         = "0.0.0.0/0"
    name                   = "to-internet"
    next_hop_in_ip_address = "10.0.1.4"
    next_hop_type          = "VirtualAppliance"
    }, {
    address_prefix         = "192.168.0.0/16"
    name                   = "to-plantB"
    next_hop_in_ip_address = "10.0.0.4"
    next_hop_type          = "VirtualAppliance"
  }]
}
resource "azurerm_route" "res-1" {
  address_prefix         = "0.0.0.0/0"
  name                   = "to-internet"
  next_hop_in_ip_address = "10.0.1.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.res-1.name
  route_table_name       = "rt-plantA"
  depends_on = [
    azurerm_route_table.res-1,
  ]
}
resource "azurerm_route" "res-2" {
  address_prefix         = "192.168.0.0/16"
  name                   = "to-plantB"
  next_hop_in_ip_address = "10.0.0.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.res-1.name
  route_table_name       = "rt-plantA"
  depends_on = [
    azurerm_route_table.res-1,
  ]
}
resource "azurerm_route_table" "res-2" {
  location            = "eastus"
  name                = "rt-plantB"
  resource_group_name = azurerm_resource_group.res-1.name
  route = [{
    address_prefix         = "172.16.0.0/16"
    name                   = "to-plantA"
    next_hop_in_ip_address = "10.0.0.4"
    next_hop_type          = "VirtualAppliance"
  }]
}
resource "azurerm_route" "res-3" {
  address_prefix         = "172.16.0.0/16"
  name                   = "to-plantA"
  next_hop_in_ip_address = "10.0.0.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = azurerm_resource_group.res-1.name
  route_table_name       = "rt-plantB"
  depends_on = [
    azurerm_route_table.res-2,
  ]
}
resource "azurerm_virtual_network_gateway" "res-1" {
  generation          = "Generation2"
  location            = "eastus"
  name                = "VPN-Hub"
  resource_group_name = azurerm_resource_group.res-1.name
  sku                 = "VpnGw2AZ"
  type                = "Vpn"
  bgp_settings {
    asn = 65515
    peering_addresses {
      ip_configuration_name = "default"
    }
  }
  ip_configuration {
    name                 = "default"
    public_ip_address_id = azurerm_public_ip.res-2.id
    subnet_id            = azurerm_subnet.res-3.id
  }
}
resource "azurerm_virtual_network_gateway" "res-2" {
  generation          = "Generation2"
  location            = "eastus"
  name                = "VPN-Office"
  resource_group_name = azurerm_resource_group.res-1.name
  sku                 = "VpnGw2AZ"
  type                = "Vpn"
  bgp_settings {
    asn = 65515
    peering_addresses {
      ip_configuration_name = "default"
    }
  }
  ip_configuration {
    name                 = "default"
    public_ip_address_id = azurerm_public_ip.res-3.id
    subnet_id            = azurerm_subnet.res-5.id
  }
}
resource "azurerm_virtual_network" "res-1" {
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  name                = "HUB-Vnet"
  resource_group_name = azurerm_resource_group.res-1.name
  subnet = [{
    address_prefixes                              = ["10.0.0.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/HUB-Vnet/subnets/NVA-Subnet"
    name                                          = "NVA-Subnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.1.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/HUB-Vnet/subnets/AzureFirewallSubnet"
    name                                          = "AzureFirewallSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.2.0/26"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/HUB-Vnet/subnets/AzureBastionSubnet"
    name                                          = "AzureBastionSubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.0.3.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/HUB-Vnet/subnets/GatewaySubnet"
    name                                          = "GatewaySubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
}
resource "azurerm_subnet" "res-1" {
  address_prefixes                = ["10.0.2.0/26"]
  default_outbound_access_enabled = false
  name                            = "AzureBastionSubnet"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_subnet" "res-2" {
  address_prefixes                = ["10.0.1.0/26"]
  default_outbound_access_enabled = false
  name                            = "AzureFirewallSubnet"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_subnet" "res-3" {
  address_prefixes                = ["10.0.3.0/24"]
  default_outbound_access_enabled = false
  name                            = "GatewaySubnet"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_subnet" "res-4" {
  address_prefixes                = ["10.0.0.0/24"]
  default_outbound_access_enabled = false
  name                            = "NVA-Subnet"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_virtual_network_peering" "res-1" {
  allow_gateway_transit     = true
  name                      = "HUB-to-plantA"
  remote_virtual_network_id = azurerm_virtual_network.res-3.id
  resource_group_name       = azurerm_resource_group.res-1.name
  virtual_network_name      = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_virtual_network_peering" "res-2" {
  name                      = "HUB-to-plantB"
  remote_virtual_network_id = azurerm_virtual_network.res-4.id
  resource_group_name       = azurerm_resource_group.res-1.name
  virtual_network_name      = "HUB-Vnet"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
resource "azurerm_virtual_network" "res-2" {
  address_space       = ["10.5.0.0/16"]
  location            = "eastus"
  name                = "Office-Vnet"
  resource_group_name = azurerm_resource_group.res-1.name
  subnet = [{
    address_prefixes                              = ["10.5.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/Office-Vnet/subnets/GatewaySubnet"
    name                                          = "GatewaySubnet"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["10.5.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/Office-Vnet/subnets/snet-office"
    name                                          = "snet-office"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
}
resource "azurerm_subnet" "res-5" {
  address_prefixes                = ["10.5.1.0/24"]
  default_outbound_access_enabled = false
  name                            = "GatewaySubnet"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "Office-Vnet"
  depends_on = [
    azurerm_virtual_network.res-2,
  ]
}
resource "azurerm_subnet" "res-6" {
  address_prefixes                = ["10.5.2.0/24"]
  default_outbound_access_enabled = false
  name                            = "snet-office"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "Office-Vnet"
  depends_on = [
    azurerm_virtual_network.res-2,
  ]
}
resource "azurerm_virtual_network" "res-3" {
  address_space       = ["172.16.0.0/16"]
  location            = "eastus"
  name                = "plant_A_Vnet"
  resource_group_name = azurerm_resource_group.res-1.name
  subnet = [{
    address_prefixes                              = ["172.16.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = azurerm_subnet_route_table_association.res-2.id
    name                                          = "snet-Server"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.res-1.id
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["172.16.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_A_Vnet/subnets/snet-OT"
    name                                          = "snet-OT"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.res-1.id
    security_group                                = azurerm_network_security_group.res-1.id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  depends_on = [
    # One of azurerm_subnet_network_security_group_association.res-1,azurerm_subnet_route_table_association.res-1 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet" "res-7" {
  address_prefixes                = ["172.16.2.0/24"]
  default_outbound_access_enabled = false
  name                            = "snet-OT"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "plant_A_Vnet"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-1" {
  network_security_group_id = azurerm_network_security_group.res-1.id
  subnet_id                 = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_A_Vnet/subnets/snet-OT"
  depends_on = [
    azurerm_subnet.res-7,
    # One of azurerm_subnet.res-7,azurerm_subnet_route_table_association.res-1 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet_route_table_association" "res-1" {
  route_table_id = azurerm_route_table.res-1.id
  subnet_id      = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_A_Vnet/subnets/snet-OT"
  depends_on = [
    azurerm_subnet.res-7,
    # One of azurerm_subnet.res-7,azurerm_subnet_network_security_group_association.res-1 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet" "res-8" {
  address_prefixes                = ["172.16.1.0/24"]
  default_outbound_access_enabled = false
  name                            = "snet-Server"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "plant_A_Vnet"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}
resource "azurerm_subnet_route_table_association" "res-2" {
  route_table_id = azurerm_route_table.res-1.id
  subnet_id      = azurerm_subnet.res-8.id
}
resource "azurerm_virtual_network_peering" "res-3" {
  allow_forwarded_traffic   = true
  name                      = "plantA-to-HUB"
  remote_virtual_network_id = azurerm_virtual_network.res-1.id
  resource_group_name       = azurerm_resource_group.res-1.name
  use_remote_gateways       = true
  virtual_network_name      = "plant_A_Vnet"
  depends_on = [
    azurerm_virtual_network.res-3,
  ]
}
resource "azurerm_virtual_network" "res-4" {
  address_space       = ["192.168.0.0/16"]
  location            = "eastus"
  name                = "plant_B_Vnet"
  resource_group_name = azurerm_resource_group.res-1.name
  subnet = [{
    address_prefixes                              = ["192.168.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = azurerm_subnet_route_table_association.res-4.id
    name                                          = "snet-Server"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.res-2.id
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
    }, {
    address_prefixes                              = ["192.168.2.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_B_Vnet/subnets/snet-OT"
    name                                          = "snet-OT"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = azurerm_route_table.res-2.id
    security_group                                = azurerm_network_security_group.res-1.id
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  depends_on = [
    # One of azurerm_subnet_network_security_group_association.res-2,azurerm_subnet_route_table_association.res-3 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet" "res-9" {
  address_prefixes                = ["192.168.2.0/24"]
  default_outbound_access_enabled = false
  name                            = "snet-OT"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "plant_B_Vnet"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}
resource "azurerm_subnet_network_security_group_association" "res-2" {
  network_security_group_id = azurerm_network_security_group.res-1.id
  subnet_id                 = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_B_Vnet/subnets/snet-OT"
  depends_on = [
    azurerm_subnet.res-9,
    # One of azurerm_subnet.res-9,azurerm_subnet_route_table_association.res-3 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet_route_table_association" "res-3" {
  route_table_id = azurerm_route_table.res-2.id
  subnet_id      = "/subscriptions/83a28882-abad-46fe-ab07-039048c51020/resourceGroups/Project_2/providers/Microsoft.Network/virtualNetworks/plant_B_Vnet/subnets/snet-OT"
  depends_on = [
    azurerm_subnet.res-9,
    # One of azurerm_subnet.res-9,azurerm_subnet_network_security_group_association.res-2 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_subnet" "res-10" {
  address_prefixes                = ["192.168.1.0/24"]
  default_outbound_access_enabled = false
  name                            = "snet-Server"
  resource_group_name             = azurerm_resource_group.res-1.name
  virtual_network_name            = "plant_B_Vnet"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}
resource "azurerm_subnet_route_table_association" "res-4" {
  route_table_id = azurerm_route_table.res-2.id
  subnet_id      = azurerm_subnet.res-10.id
}
resource "azurerm_virtual_network_peering" "res-4" {
  allow_forwarded_traffic   = true
  name                      = "plantB-to-HUB"
  remote_virtual_network_id = azurerm_virtual_network.res-1.id
  resource_group_name       = azurerm_resource_group.res-1.name
  virtual_network_name      = "plant_B_Vnet"
  depends_on = [
    azurerm_virtual_network.res-4,
  ]
}
resource "azurerm_private_dns_a_record" "res-1" {
  name                = "gsa-edc7d1c5-9dbc000000"
  records             = ["10.0.1.5"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-2" {
  name                = "gsa-edc7d1c5-9dbc000001"
  records             = ["10.0.1.6"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-3" {
  name                = "vm-nva"
  records             = ["10.0.0.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-4" {
  name                = "vm-office"
  records             = ["10.5.2.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-5" {
  name                = "vm-planta-ot"
  records             = ["172.16.2.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-6" {
  name                = "vm-planta-serve"
  records             = ["172.16.1.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-7" {
  name                = "vm-plantb-serve"
  records             = ["192.168.1.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-8" {
  name                = "vpngw000000"
  records             = ["10.0.3.5"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
resource "azurerm_private_dns_a_record" "res-9" {
  name                = "vpngw000001"
  records             = ["10.0.3.4"]
  resource_group_name = "project_2"
  ttl                 = 10
  zone_name           = "internal.dns"
  depends_on = [
    azurerm_private_dns_zone.res-1,
  ]
}
