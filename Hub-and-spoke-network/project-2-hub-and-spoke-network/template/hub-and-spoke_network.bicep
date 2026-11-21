param azureFirewalls_fw_hub_name string = 'fw-hub'
param routeTables_rt_plantA_name string = 'rt-plantA'
param routeTables_rt_plantB_name string = 'rt-plantB'
param virtualMachines_vm_NVA_name string = 'vm-NVA'
param firewallPolicies_fwp_hub_name string = 'fwp-hub'
param publicIPAddresses_ip_vpn_name string = 'ip-vpn'
param virtualNetworks_HUB_Vnet_name string = 'HUB-Vnet'
param virtualMachines_vm_office_name string = 'vm-office'
param connections_hub_to_office_name string = 'hub-to-office'
param connections_office_to_hub_name string = 'office-to-hub'
param networkInterfaces_vm_nva624_name string = 'vm-nva624'
param virtualNetworks_Office_Vnet_name string = 'Office-Vnet'
param virtualMachines_vm_plantA_OT_name string = 'vm-plantA-OT'
param networkSecurityGroups_nsg_OT_name string = 'nsg-OT'
param privateDnsZones_internal_dns_name string = 'internal.dns'
param publicIPAddresses_pip_fw_hub_name string = 'pip-fw-hub'
param virtualNetworks_plant_A_Vnet_name string = 'plant_A_Vnet'
param virtualNetworks_plant_B_Vnet_name string = 'plant_B_Vnet'
param networkInterfaces_vm_office475_name string = 'vm-office475'
param virtualNetworkGateways_VPN_Hub_name string = 'VPN-Hub'
param publicIPAddresses_pip_Hub_vpnip_name string = 'pip-Hub-vpnip'
param publicIPAddresses_pip_VPNoffice_name string = 'pip-VPNoffice'
param virtualMachines_vm_plantA_server_name string = 'vm-plantA-server'
param virtualMachines_vm_plantB_server_name string = 'vm-plantB-server'
param networkInterfaces_vm_planta_ot942_name string = 'vm-planta-ot942'
param virtualNetworkGateways_VPN_Office_name string = 'VPN-Office'
param networkInterfaces_vm_planta_server35_name string = 'vm-planta-server35'
param networkInterfaces_vm_plantb_server695_name string = 'vm-plantb-server695'

resource firewallPolicies_fwp_hub_name_resource 'Microsoft.Network/firewallPolicies@2025-09-01' = {
  name: firewallPolicies_fwp_hub_name
  location: 'eastus'
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
  }
}

resource networkSecurityGroups_nsg_OT_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_OT_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'Deny-Internet-Out'
        id: networkSecurityGroups_nsg_OT_name_Deny_Internet_Out.id
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: 'Internet'
          priority: 2000
          protocol: '*'
          access: 'Deny'
          direction: 'Outbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_internal_dns_name
  location: 'global'
  properties: {}
}

resource publicIPAddresses_ip_vpn_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_ip_vpn_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '20.242.242.222'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_pip_fw_hub_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_pip_fw_hub_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.102.71.111'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_pip_Hub_vpnip_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_pip_Hub_vpnip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '4.255.20.64'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIPAddresses_pip_VPNoffice_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_pip_VPNoffice_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '4.255.105.44'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource routeTables_rt_plantA_name_resource 'Microsoft.Network/routeTables@2025-09-01' = {
  name: routeTables_rt_plantA_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'to-plantB'
        id: routeTables_rt_plantA_name_to_plantB.id
        properties: {
          addressPrefix: '192.168.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.0.4'
        }
      }
      {
        name: 'to-internet'
        id: routeTables_rt_plantA_name_to_internet.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.1.4'
        }
      }
    ]
  }
}

resource routeTables_rt_plantB_name_resource 'Microsoft.Network/routeTables@2025-09-01' = {
  name: routeTables_rt_plantB_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'to-plantA'
        id: routeTables_rt_plantB_name_to_plantA.id
        properties: {
          addressPrefix: '172.16.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.0.4'
        }
      }
    ]
  }
}

resource virtualNetworks_Office_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_Office_Vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.5.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_Office_Vnet_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.5.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-office'
        id: virtualNetworks_Office_Vnet_name_snet_office.id
        properties: {
          addressPrefixes: [
            '10.5.2.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_vm_NVA_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_NVA_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F1als_v7'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_NVA_name}_OsDisk_1_c8d7938034c949e2a2abd4638ab214ce'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_NVA_name}_OsDisk_1_c8d7938034c949e2a2abd4638ab214ce'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_NVA_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      securityType: 'Standard'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_nva624_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_vm_office_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_office_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F1als_v7'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_office_name}_OsDisk_1_969ff1dafe744f28a84245bdd15c3ce1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_office_name}_OsDisk_1_969ff1dafe744f28a84245bdd15c3ce1'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_office_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_office475_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_vm_plantA_OT_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_plantA_OT_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F1als_v7'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_plantA_OT_name}_OsDisk_1_a2120fd5142348b3b0ece319bff314d9'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_plantA_OT_name}_OsDisk_1_a2120fd5142348b3b0ece319bff314d9'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_plantA_OT_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_planta_ot942_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_vm_plantA_server_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_plantA_server_name
  location: 'eastus'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F1als_v7'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_plantA_server_name}_OsDisk_1_e746c76c504e4c009943accc0018b2d4'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_plantA_server_name}_OsDisk_1_e746c76c504e4c009943accc0018b2d4'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: 'vm-plantA-serve'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_planta_server35_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource virtualMachines_vm_plantB_server_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_plantB_server_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F1als_v7'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_plantB_server_name}_OsDisk_1_ca02f8fdd2f444de918962eb60e549a0'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_plantB_server_name}_OsDisk_1_ca02f8fdd2f444de918962eb60e549a0'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: 'vm-plantB-serve'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_plantb_server695_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource firewallPolicies_fwp_hub_name_DefaultNetworkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2025-09-01' = {
  parent: firewallPolicies_fwp_hub_name_resource
  name: 'DefaultNetworkRuleCollectionGroup'
  location: 'eastus'
  properties: {
    priority: 200
    ruleCollections: [
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'allow-https-out'
            ipProtocols: [
              'TCP'
            ]
            sourceAddresses: [
              '172.16.1.0/24'
              '192.168.1.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '*'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '443'
            ]
          }
        ]
        name: 'plants-out'
        priority: 100
      }
    ]
  }
}

resource networkInterfaces_vm_nva624_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_nva624_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_nva624_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.0.0.4'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: virtualNetworks_HUB_Vnet_name_NVA_Subnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: true
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_office475_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_office475_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_office475_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.5.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_Office_Vnet_name_snet_office.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_planta_ot942_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_planta_ot942_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_planta_ot942_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '172.16.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_plant_A_Vnet_name_snet_OT.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_planta_server35_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_planta_server35_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_planta_server35_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '172.16.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_plant_A_Vnet_name_snet_Server.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkInterfaces_vm_plantb_server695_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_plantb_server695_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_plantb_server695_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '192.168.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_plant_B_Vnet_name_snet_Server.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource networkSecurityGroups_nsg_OT_name_Deny_Internet_Out 'Microsoft.Network/networkSecurityGroups/securityRules@2025-09-01' = {
  name: '${networkSecurityGroups_nsg_OT_name}/Deny-Internet-Out'
  properties: {
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: 'Internet'
    priority: 2000
    protocol: '*'
    access: 'Deny'
    direction: 'Outbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_nsg_OT_name_resource
  ]
}

resource privateDnsZones_internal_dns_name_gsa_edc7d1c5_9dbc000000 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'gsa-edc7d1c5-9dbc000000'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.1.5'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_gsa_edc7d1c5_9dbc000001 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'gsa-edc7d1c5-9dbc000001'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.1.6'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vm_nva 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vm-nva'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.0.4'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vm_office 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vm-office'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.5.2.4'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vm_planta_ot 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vm-planta-ot'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '172.16.2.4'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vm_planta_serve 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vm-planta-serve'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '172.16.1.4'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vm_plantb_serve 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vm-plantb-serve'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '192.168.1.4'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vpngw000000 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vpngw000000'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.3.5'
      }
    ]
  }
}

resource privateDnsZones_internal_dns_name_vpngw000001 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'vpngw000001'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.0.3.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_internal_dns_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource routeTables_rt_plantA_name_to_internet 'Microsoft.Network/routeTables/routes@2025-09-01' = {
  name: '${routeTables_rt_plantA_name}/to-internet'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.4'
  }
  dependsOn: [
    routeTables_rt_plantA_name_resource
  ]
}

resource routeTables_rt_plantB_name_to_plantA 'Microsoft.Network/routeTables/routes@2025-09-01' = {
  name: '${routeTables_rt_plantB_name}/to-plantA'
  properties: {
    addressPrefix: '172.16.0.0/16'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.0.4'
  }
  dependsOn: [
    routeTables_rt_plantB_name_resource
  ]
}

resource routeTables_rt_plantA_name_to_plantB 'Microsoft.Network/routeTables/routes@2025-09-01' = {
  name: '${routeTables_rt_plantA_name}/to-plantB'
  properties: {
    addressPrefix: '192.168.0.0/16'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.0.4'
  }
  dependsOn: [
    routeTables_rt_plantA_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/AzureBastionSubnet'
  properties: {
    addressPrefixes: [
      '10.0.2.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/AzureFirewallSubnet'
  properties: {
    addressPrefixes: [
      '10.0.1.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.0.3.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_Office_Vnet_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_Office_Vnet_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.5.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Office_Vnet_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_NVA_Subnet 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/NVA-Subnet'
  properties: {
    addressPrefixes: [
      '10.0.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_Office_Vnet_name_snet_office 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_Office_Vnet_name}/snet-office'
  properties: {
    addressPrefixes: [
      '10.5.2.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Office_Vnet_name_resource
  ]
}

resource connections_hub_to_office_name_resource 'Microsoft.Network/connections@2025-09-01' = {
  name: connections_hub_to_office_name
  location: 'eastus'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_VPN_Hub_name_resource.id
      properties: {}
    }
    virtualNetworkGateway2: {
      id: virtualNetworkGateways_VPN_Office_name_resource.id
      properties: {}
    }
    connectionType: 'Vnet2Vnet'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    authenticationType: 'PSK'
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    tunnelProperties: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 45
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
    routingConfiguration: {}
  }
}

resource connections_office_to_hub_name_resource 'Microsoft.Network/connections@2025-09-01' = {
  name: connections_office_to_hub_name
  location: 'eastus'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_VPN_Office_name_resource.id
      properties: {}
    }
    virtualNetworkGateway2: {
      id: virtualNetworkGateways_VPN_Hub_name_resource.id
      properties: {}
    }
    connectionType: 'Vnet2Vnet'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    authenticationType: 'PSK'
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    tunnelProperties: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 45
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
    routingConfiguration: {}
  }
}

resource privateDnsZones_internal_dns_name_hub_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'hub-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_HUB_Vnet_name_resource.id
    }
  }
}

resource privateDnsZones_internal_dns_name_office_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'office-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_Office_Vnet_name_resource.id
    }
  }
}

resource privateDnsZones_internal_dns_name_planta_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'planta-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_plant_A_Vnet_name_resource.id
    }
  }
}

resource privateDnsZones_internal_dns_name_plantb_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_internal_dns_name_resource
  name: 'plantb-link'
  location: 'global'
  properties: {
    registrationEnabled: true
    virtualNetwork: {
      id: virtualNetworks_plant_B_Vnet_name_resource.id
    }
  }
}

resource virtualNetworkGateways_VPN_Hub_name_resource 'Microsoft.Network/virtualNetworkGateways@2025-09-01' = {
  name: virtualNetworkGateways_VPN_Hub_name
  location: 'eastus'
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_VPN_Hub_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip_Hub_vpnip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_HUB_Vnet_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw2AZ'
      tier: 'VpnGw2AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientProtocols: [
        'OpenVPN'
        'IkeV2'
      ]
      vpnAuthenticationTypes: []
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.0.3.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_VPN_Hub_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation2'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

resource virtualNetworkGateways_VPN_Office_name_resource 'Microsoft.Network/virtualNetworkGateways@2025-09-01' = {
  name: virtualNetworkGateways_VPN_Office_name
  location: 'eastus'
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_VPN_Office_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip_VPNoffice_name_resource.id
          }
          subnet: {
            id: virtualNetworks_Office_Vnet_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw2AZ'
      tier: 'VpnGw2AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    vpnClientConfiguration: {
      vpnClientProtocols: [
        'OpenVPN'
        'IkeV2'
      ]
      vpnAuthenticationTypes: []
      vpnClientRootCertificates: []
      vpnClientRevokedCertificates: []
      vngClientConnectionConfigurations: []
      radiusServers: []
      vpnClientIpsecPolicies: []
    }
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.5.1.254'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_VPN_Office_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation2'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

resource virtualNetworks_HUB_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_HUB_Vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_HUB_Vnet_name_AzureFirewallSubnet.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'AzureBastionSubnet'
        id: virtualNetworks_HUB_Vnet_name_AzureBastionSubnet.id
        properties: {
          addressPrefixes: [
            '10.0.2.0/26'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_HUB_Vnet_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.0.3.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'NVA-Subnet'
        id: virtualNetworks_HUB_Vnet_name_NVA_Subnet.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'HUB-to-plantA'
        id: virtualNetworks_HUB_Vnet_name_HUB_to_plantA.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_plant_A_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: true
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '172.16.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '172.16.0.0/16'
            ]
          }
        }
      }
      {
        name: 'HUB-to-plantB'
        id: virtualNetworks_HUB_Vnet_name_HUB_to_plantB.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_plant_B_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '192.168.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '192.168.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_plant_A_Vnet_name_snet_Server 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_plant_A_Vnet_name}/snet-Server'
  properties: {
    addressPrefixes: [
      '172.16.1.0/24'
    ]
    routeTable: {
      id: routeTables_rt_plantA_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_plant_A_Vnet_name_resource
  ]
}

resource virtualNetworks_plant_B_Vnet_name_snet_Server 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_plant_B_Vnet_name}/snet-Server'
  properties: {
    addressPrefixes: [
      '192.168.1.0/24'
    ]
    routeTable: {
      id: routeTables_rt_plantB_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_plant_B_Vnet_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_HUB_to_plantA 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/HUB-to-plantA'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_plant_A_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: true
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_HUB_Vnet_name_HUB_to_plantB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01' = {
  name: '${virtualNetworks_HUB_Vnet_name}/HUB-to-plantB'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_plant_B_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_HUB_Vnet_name_resource
  ]
}

resource virtualNetworks_plant_A_Vnet_name_plantA_to_HUB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01' = {
  name: '${virtualNetworks_plant_A_Vnet_name}/plantA-to-HUB'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_HUB_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_plant_A_Vnet_name_resource
  ]
}

resource virtualNetworks_plant_B_Vnet_name_plantB_to_HUB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01' = {
  name: '${virtualNetworks_plant_B_Vnet_name}/plantB-to-HUB'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_HUB_Vnet_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_plant_B_Vnet_name_resource
  ]
}

resource azureFirewalls_fw_hub_name_resource 'Microsoft.Network/azureFirewalls@2025-09-01' = {
  name: azureFirewalls_fw_hub_name
  location: 'eastus'
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    ipConfigurations: [
      {
        name: 'pip-${azureFirewalls_fw_hub_name}'
        id: '${azureFirewalls_fw_hub_name_resource.id}/azureFirewallIpConfigurations/pip-${azureFirewalls_fw_hub_name}'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_pip_fw_hub_name_resource.id
          }
          subnet: {
            id: virtualNetworks_HUB_Vnet_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
    firewallPolicy: {
      id: firewallPolicies_fwp_hub_name_resource.id
    }
  }
}

resource virtualNetworks_plant_A_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_plant_A_Vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-Server'
        id: virtualNetworks_plant_A_Vnet_name_snet_Server.id
        properties: {
          addressPrefixes: [
            '172.16.1.0/24'
          ]
          routeTable: {
            id: routeTables_rt_plantA_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-OT'
        id: virtualNetworks_plant_A_Vnet_name_snet_OT.id
        properties: {
          addressPrefixes: [
            '172.16.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_OT_name_resource.id
          }
          routeTable: {
            id: routeTables_rt_plantA_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'plantA-to-HUB'
        id: virtualNetworks_plant_A_Vnet_name_plantA_to_HUB.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_HUB_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: true
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_plant_B_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_plant_B_Vnet_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-Server'
        id: virtualNetworks_plant_B_Vnet_name_snet_Server.id
        properties: {
          addressPrefixes: [
            '192.168.1.0/24'
          ]
          routeTable: {
            id: routeTables_rt_plantB_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-OT'
        id: virtualNetworks_plant_B_Vnet_name_snet_OT.id
        properties: {
          addressPrefixes: [
            '192.168.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_OT_name_resource.id
          }
          routeTable: {
            id: routeTables_rt_plantB_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'plantB-to-HUB'
        id: virtualNetworks_plant_B_Vnet_name_plantB_to_HUB.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_HUB_Vnet_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_plant_A_Vnet_name_snet_OT 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_plant_A_Vnet_name}/snet-OT'
  properties: {
    addressPrefixes: [
      '172.16.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_OT_name_resource.id
    }
    routeTable: {
      id: routeTables_rt_plantA_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_plant_A_Vnet_name_resource
  ]
}

resource virtualNetworks_plant_B_Vnet_name_snet_OT 'Microsoft.Network/virtualNetworks/subnets@2025-09-01' = {
  name: '${virtualNetworks_plant_B_Vnet_name}/snet-OT'
  properties: {
    addressPrefixes: [
      '192.168.2.0/24'
    ]
    networkSecurityGroup: {
      id: networkSecurityGroups_nsg_OT_name_resource.id
    }
    routeTable: {
      id: routeTables_rt_plantB_name_resource.id
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_plant_B_Vnet_name_resource
  ]
}
