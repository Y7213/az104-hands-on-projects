param loadBalancers_plb_p3_name string = 'plb-p3'
param virtualMachines_vm_db_name string = 'vm-db'
param virtualMachines_vm_app_name string = 'vm-app'
param virtualMachines_web_vm1_name string = 'web-vm1'
param virtualMachines_web_vm2_name string = 'web-vm2'
param virtualNetworks_P3_Vnet_name string = 'P3_Vnet'
param natGateways_NAT_project3_name string = 'NAT-project3'
param loadBalancers_internal_lb_name string = 'internal-lb'
param networkInterfaces_vm_db22_name string = 'vm-db22'
param publicIPAddresses_nat_pip_name string = 'nat-pip'
param networkInterfaces_vm_app298_name string = 'vm-app298'
param networkInterfaces_web_vm1462_name string = 'web-vm1462'
param networkInterfaces_web_vm2475_name string = 'web-vm2475'
param networkSecurityGroups_nsg_db_name string = 'nsg-db'
param publicIPAddresses_pip_web_p3_name string = 'pip-web-p3'
param vaults_vm_db_backup_name string = 'vm-db-backup'
param bastionHosts_project3_bastion_name string = 'project3-bastion'
param networkSecurityGroups_nsg_app_name string = 'nsg-app'
param networkSecurityGroups_nsg_web_name string = 'nsg-web'
param publicIPAddresses_pip_bastion_name string = 'pip-bastion'
param storageAccounts_p3storagedb8907_name string = 'p3storage${uniqueString(resourceGroup().id)}'
param applicationSecurityGroups_asg_db_name string = 'asg-db'
param applicationSecurityGroups_asg_app_name string = 'asg-app'
param applicationSecurityGroups_asg_web_name string = 'asg-web'

@description('Admin password for the four Linux VMs. Never commit a real value.')
@secure()
param adminPassword string
param location string = resourceGroup().location

resource applicationSecurityGroups_asg_app_name_resource 'Microsoft.Network/applicationSecurityGroups@2025-09-01' = {
  name: applicationSecurityGroups_asg_app_name
  location: location
  properties: {}
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource applicationSecurityGroups_asg_db_name_resource 'Microsoft.Network/applicationSecurityGroups@2025-09-01' = {
  name: applicationSecurityGroups_asg_db_name
  location: location
  properties: {}
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource applicationSecurityGroups_asg_web_name_resource 'Microsoft.Network/applicationSecurityGroups@2025-09-01' = {
  name: applicationSecurityGroups_asg_web_name
  location: location
  properties: {}
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource publicIPAddresses_pip_bastion_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_pip_bastion_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '2'
    '1'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource publicIPAddresses_pip_web_p3_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_pip_web_p3_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '2'
    '1'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource vaults_vm_db_backup_name_resource 'Microsoft.RecoveryServices/vaults@2026-07-01' = {
  name: vaults_vm_db_backup_name
  location: location
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
  properties: {
    securitySettings: {
      softDeleteSettings: {
        softDeleteRetentionPeriodInDays: 14
        softDeleteState: 'Enabled'
        enhancedSecurityState: 'Enabled'
      }
      sourceScanConfiguration: {
        state: 'Disabled'
      }
    }
    redundancySettings: {
      standardTierStorageRedundancy: 'GeoRedundant'
      crossRegionRestore: 'Disabled'
    }
    regionOfChoiceSettings: {
      status: 'Disabled'
    }
    publicNetworkAccess: 'Enabled'
    restoreSettings: {
      crossSubscriptionRestoreSettings: {
        crossSubscriptionRestoreState: 'Enabled'
      }
    }
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource virtualMachines_vm_app_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_app_name
  location: location
  zones: [
    '2'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_app_name}_OsDisk_1_258a0cac515245d9b76852dc0414a925'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_app_name}_OsDisk_1_258a0cac515245d9b76852dc0414a925'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_app_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
      adminPassword: adminPassword
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
          id: networkInterfaces_vm_app298_name_resource.id
          properties: {
            deleteOption: 'Delete'
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource virtualMachines_vm_db_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_vm_db_name
  location: location
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm_db_name}_OsDisk_1_9f4d951005dd451581ee224adab0e82b'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm_db_name}_OsDisk_1_9f4d951005dd451581ee224adab0e82b'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: [
        {
          lun: 0
          name: '${virtualMachines_vm_db_name}_databasedisk'
          createOption: 'Empty'
          caching: 'ReadOnly'
          writeAcceleratorEnabled: false
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
            id: resourceId('Microsoft.Compute/disks', '${virtualMachines_vm_db_name}_databasedisk')
          }
          deleteOption: 'Detach'
          diskSizeGB: 4
          toBeDetached: false
        }
      ]
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_vm_db_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
      adminPassword: adminPassword
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
          id: networkInterfaces_vm_db22_name_resource.id
          properties: {
            deleteOption: 'Delete'
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource virtualMachines_web_vm1_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_web_vm1_name
  location: location
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_web_vm1_name}_OsDisk_1_d99941758d394fbea7566b8bd5f80944'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_web_vm1_name}_OsDisk_1_d99941758d394fbea7566b8bd5f80944'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_web_vm1_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
      adminPassword: adminPassword
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
          id: networkInterfaces_web_vm1462_name_resource.id
          properties: {
            deleteOption: 'Delete'
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource virtualMachines_web_vm2_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_web_vm2_name
  location: location
  zones: [
    '2'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_web_vm2_name}_disk1_943b26d3d43048f9af398bf133187fb5'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_web_vm2_name}_disk1_943b26d3d43048f9af398bf133187fb5'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_web_vm2_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
      adminPassword: adminPassword
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
          id: networkInterfaces_web_vm2475_name_resource.id
          properties: {
            deleteOption: 'Delete'
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource loadBalancers_internal_lb_name_resource 'Microsoft.Network/loadBalancers@2025-09-01' = {
  name: loadBalancers_internal_lb_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancers_internal_lb_name
        properties: {
          privateIPAddress: '10.30.2.10'
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_app')
          }
          privateIPAddressVersion: 'IPv4'
        }
        zones: [
          '2'
          '1'
          '3'
        ]
      }
    ]
    backendAddressPools: [
      {
        name: '${loadBalancers_internal_lb_name}-pool'
        properties: {}
      }
    ]
    loadBalancingRules: [
      {
        name: '${loadBalancers_internal_lb_name}-rule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancers_internal_lb_name, loadBalancers_internal_lb_name)
          }
          frontendPort: 8080
          backendPort: 8080
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          enableConnectionTracking: false
          backendAddressPool: {
            id: resourceId(
              'Microsoft.Network/loadBalancers/backendAddressPools',
              loadBalancers_internal_lb_name,
              '${loadBalancers_internal_lb_name}-pool'
            )
          }
          backendAddressPools: [
            {
              id: resourceId(
                'Microsoft.Network/loadBalancers/backendAddressPools',
                loadBalancers_internal_lb_name,
                '${loadBalancers_internal_lb_name}-pool'
              )
            }
          ]
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancers_internal_lb_name, '${loadBalancers_internal_lb_name}-app-healthprobe')
          }
        }
      }
    ]
    probes: [
      {
        name: '${loadBalancers_internal_lb_name}-app-healthprobe'
        properties: {
          protocol: 'Tcp'
          port: 8080
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
          noHealthyBackendsBehavior: 'AllProbedDown'
        }
      }
    ]
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource
  ]
}

resource loadBalancers_plb_p3_name_resource 'Microsoft.Network/loadBalancers@2025-09-01' = {
  name: loadBalancers_plb_p3_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'fe-web'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip_web_p3_name_resource.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bp-web'
        properties: {}
      }
    ]
    loadBalancingRules: [
      {
        name: 'rule-http'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', loadBalancers_plb_p3_name, 'fe-web')
          }
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          enableConnectionTracking: false
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancers_plb_p3_name, 'bp-web')
          }
          backendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancers_plb_p3_name, 'bp-web')
            }
          ]
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancers_plb_p3_name, 'probe-http')
          }
        }
      }
    ]
    probes: [
      {
        name: 'probe-http'
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
          noHealthyBackendsBehavior: 'AllProbedDown'
        }
      }
    ]
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource natGateways_NAT_project3_name_resource 'Microsoft.Network/natGateways@2025-09-01' = {
  name: natGateways_NAT_project3_name
  location: location
  sku: {
    name: 'StandardV2'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_nat_pip_name_resource.id
      }
    ]
    nat64: 'Disabled'
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource networkSecurityGroups_nsg_web_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_web_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-http'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: 'Internet'
          priority: 100
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
        }
      }
      {
        name: 'allow-bastion'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '10.30.4.0/26'
          priority: 120
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
        }
      }
    ]
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource publicIPAddresses_nat_pip_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_nat_pip_name
  location: location
  sku: {
    name: 'StandardV2'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: []
}

resource vaults_vm_db_backup_name_DefaultPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'DefaultPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V1'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        '2026-11-18T08:00:00Z'
      ]
      scheduleWeeklyFrequency: 0
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-11-18T08:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
  }
}

resource vaults_vm_db_backup_name_EnhancedPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'EnhancedPolicy'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Hourly'
      hourlySchedule: {
        interval: 4
        scheduleWindowStartTime: '2026-11-18T08:00:00Z'
        scheduleWindowDuration: 12
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      dailySchedule: {
        retentionTimes: [
          '2026-11-18T08:00:00Z'
        ]
        retentionDuration: {
          count: 30
          durationType: 'Days'
        }
      }
    }
    instantRpRetentionRangeInDays: 2
    timeZone: 'UTC'
  }
}

resource vaults_vm_db_backup_name_EnhancedPolicy_mwl9exne 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'EnhancedPolicy-mwl9exne'
  properties: {
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'
    instantRPDetails: {}
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Weekly'
      weeklySchedule: {
        scheduleRunDays: [
          'Sunday'
        ]
        scheduleRunTimes: [
          '2026-11-18T12:00:00Z'
        ]
      }
    }
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionTimes: [
          '2026-11-18T12:00:00Z'
        ]
        retentionDuration: {
          count: 12
          durationType: 'Weeks'
        }
      }
    }
    instantRpRetentionRangeInDays: 7
    timeZone: 'UTC'
  }
}

resource vaults_vm_db_backup_name_HourlyLogBackup 'Microsoft.RecoveryServices/vaults/backupPolicies@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'HourlyLogBackup'
  properties: {
    backupManagementType: 'AzureWorkload'
    workLoadType: 'SQLDataBase'
    settings: {
      timeZone: 'UTC'
      issqlcompression: false
      isCompression: false
    }
    subProtectionPolicy: [
      {
        policyType: 'Full'
        schedulePolicy: {
          schedulePolicyType: 'SimpleSchedulePolicy'
          scheduleRunFrequency: 'Daily'
          scheduleRunTimes: [
            '2026-11-18T08:00:00Z'
          ]
          scheduleWeeklyFrequency: 0
        }
        retentionPolicy: {
          retentionPolicyType: 'LongTermRetentionPolicy'
          dailySchedule: {
            retentionTimes: [
              '2026-11-18T08:00:00Z'
            ]
            retentionDuration: {
              count: 30
              durationType: 'Days'
            }
          }
        }
      }
      {
        policyType: 'Log'
        schedulePolicy: {
          schedulePolicyType: 'LogSchedulePolicy'
          scheduleFrequencyInMins: 60
        }
        retentionPolicy: {
          retentionPolicyType: 'SimpleRetentionPolicy'
          retentionDuration: {
            count: 30
            durationType: 'Days'
          }
        }
      }
    ]
  }
}

resource vaults_vm_db_backup_name_defaultAlertSetting 'Microsoft.RecoveryServices/vaults/replicationAlertSettings@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'defaultAlertSetting'
  properties: {
    sendToOwners: 'DoNotSend'
    customEmailAddresses: []
  }
}

resource vaults_vm_db_backup_name_default 'Microsoft.RecoveryServices/vaults/replicationVaultSettings@2026-07-01' = {
  parent: vaults_vm_db_backup_name_resource
  name: 'default'
  properties: {}
}

resource storageAccounts_p3storagedb8907_name_resource 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccounts_p3storagedb8907_name
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantDelegationSas: false
    dualStackEndpointPreference: {
      publishIpv6Endpoint: false
    }
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_app')
          action: 'Allow'
        }
      ]
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource
  ]
}

resource storageAccounts_p3storagedb8907_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: storageAccounts_p3storagedb8907_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_p3storagedb8907_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: storageAccounts_p3storagedb8907_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
        encryptionInTransit: {
          required: true
        }
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_p3storagedb8907_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: storageAccounts_p3storagedb8907_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_p3storagedb8907_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: storageAccounts_p3storagedb8907_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource bastionHosts_project3_bastion_name_resource 'Microsoft.Network/bastionHosts@2025-09-01' = {
  name: bastionHosts_project3_bastion_name
  location: location
  sku: {
    name: 'Basic'
  }
  zones: [
    '2'
    '1'
    '3'
  ]
  properties: {
    scaleUnits: 2
    enableTunneling: false
    enableIpConnect: false
    disableCopyPaste: false
    enableShareableLink: false
    enableKerberos: false
    enableSessionRecording: false
    enablePrivateOnlyBastion: false
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip_bastion_name_resource.id
          }
          subnet: {
            id: resourceId(
              'Microsoft.Network/virtualNetworks/subnets',
              virtualNetworks_P3_Vnet_name,
              'AzureBastionSubnet'
            )
          }
        }
      }
    ]
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource
  ]
}

resource networkInterfaces_vm_db22_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_db22_name
  location: location
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.30.3.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_db')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_db_name_resource.id
            }
          ]
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource
  ]
}

resource networkSecurityGroups_nsg_app_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_app_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-web-to-app'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '8080'
          priority: 100
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          sourceApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_app_name_resource.id
            }
          ]
        }
      }
      {
        name: 'allow-bastion-app'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '10.30.4.0/26'
          priority: 120
          description: 'Allow SSH from Azure Bastion subnet'
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_app_name_resource.id
            }
          ]
        }
      }
      {
        name: 'Deny-Vnet'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          priority: 4000
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-LB'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '8080'
          sourceAddressPrefix: 'AzureLoadBalancer'
          priority: 1000
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_app_name_resource.id
            }
          ]
        }
      }
    ]
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource networkSecurityGroups_nsg_db_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_nsg_db_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-app-to-db'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '5432'
          priority: 100
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          sourceApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_app_name_resource.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_db_name_resource.id
            }
          ]
        }
      }
      {
        name: 'Deny-Vnet'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          priority: 2000
          protocol: '*'
          access: 'Deny'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'allow-bastion'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '10.30.4.0/26'
          priority: 120
          protocol: 'TCP'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
          destinationApplicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_db_name_resource.id
            }
          ]
        }
      }
    ]
  }
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}

resource storageAccounts_p3storagedb8907_name_default_casefiles 'Microsoft.Storage/storageAccounts/fileServices/shares@2026-06-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_p3storagedb8907_name_default
  name: 'casefiles'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 102400
    enabledProtocols: 'SMB'
  }
  dependsOn: [
    storageAccounts_p3storagedb8907_name_resource
  ]
}

resource networkInterfaces_vm_app298_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_vm_app298_name
  location: location
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.30.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_app')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_app_name_resource.id
            }
          ]
          loadBalancerBackendAddressPools: [
            {
              id: resourceId(
                'Microsoft.Network/loadBalancers/backendAddressPools',
                loadBalancers_internal_lb_name,
                '${loadBalancers_internal_lb_name}-pool'
              )
            }
          ]
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource

    loadBalancers_internal_lb_name_resource
  ]
}

resource networkInterfaces_web_vm1462_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_web_vm1462_name
  location: location
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.30.1.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_web')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancers_plb_p3_name, 'bp-web')
            }
          ]
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource

    loadBalancers_plb_p3_name_resource
  ]
}

resource networkInterfaces_web_vm2475_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_web_vm2475_name
  location: location
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.30.1.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_P3_Vnet_name, 'snet_web')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroups_asg_web_name_resource.id
            }
          ]
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancers_plb_p3_name, 'bp-web')
            }
          ]
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  dependsOn: [
    virtualNetworks_P3_Vnet_name_resource

    loadBalancers_plb_p3_name_resource
  ]
}

resource virtualNetworks_P3_Vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_P3_Vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet_web'
        properties: {
          addressPrefixes: [
            '10.30.1.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_web_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet_db'
        properties: {
          addressPrefixes: [
            '10.30.3.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_db_name_resource.id
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet_app'
        properties: {
          addressPrefixes: [
            '10.30.2.0/24'
          ]
          networkSecurityGroup: {
            id: networkSecurityGroups_nsg_app_name_resource.id
          }
          natGateway: {
            id: natGateways_NAT_project3_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'eastus'
                'westus'
                'westus3'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefixes: [
            '10.30.4.0/26'
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
  tags: {
    project: 'project_3'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
}
