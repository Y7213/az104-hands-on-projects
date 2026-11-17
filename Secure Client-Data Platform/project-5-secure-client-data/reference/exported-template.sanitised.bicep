param virtualMachines_P5_VM_name string = 'P5-VM'
param virtualNetworks_p5_vnet_name string = 'p5-vnet'
param networkInterfaces_p5_vm870_name string = 'p5-vm870'
param publicIPAddresses_P5_VM_ip_name string = 'P5-VM-ip'
param storageAccounts_clientxxxxxa_name string = 'clientxxxxxa'
param storageAccounts_clientxxxxxb_name string = 'clientxxxxxb'
param storageAccounts_clientxxxxxc_name string = 'clientxxxxxc'
param networkSecurityGroups_P5_VM_nsg_name string = 'P5-VM-nsg'
param privateEndpoints_pe_clienta_blob_name string = 'pe-clienta-blob'
param workspaces_project5_logs_name string = 'project5-logs'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'

resource networkSecurityGroups_P5_VM_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-09-01' = {
  name: networkSecurityGroups_P5_VM_nsg_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    securityRules: [
      {
        name: 'RDP'
        properties: {
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          priority: 300
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {}
}

resource publicIPAddresses_P5_VM_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-09-01' = {
  name: publicIPAddresses_P5_VM_ip_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  sku: {
    name: 'Standard'
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
}

resource virtualNetworks_p5_vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-09-01' = {
  name: virtualNetworks_p5_vnet_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-endpoints'
        id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_p5_vnet_name, 'snet-endpoints')
        properties: {
          addressPrefixes: [
            '10.50.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'snet-vm'
        id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_p5_vnet_name, 'snet-vm')
        properties: {
          addressPrefixes: [
            '10.50.2.0/24'
          ]
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
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource workspaces_project5_logs_name_resource 'Microsoft.OperationalInsights/workspaces@2026-03-01' = {
  name: workspaces_project5_logs_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    sku: {
      name: 'pergb2018'
    }
    retentionInDays: 30
    features: {
      legacy: 0
      searchVersion: 1
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource storageAccounts_clientxxxxxa_name_resource 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccounts_clientxxxxxa_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
    client: 'clienta'
    dataClassification: 'confidential'
  }
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
    allowSharedKeyAccess: false
    networkAcls: {
      ipv6Rules: []
      resourceAccessRules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: [
        {
          value: '203.0.113.10'
          action: 'Allow'
        }
      ]
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
}

resource storageAccounts_clientxxxxxb_name_resource 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccounts_clientxxxxxb_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
    client: 'clientb'
    dataClassification: 'confidential'
  }
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
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
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
}

resource storageAccounts_clientxxxxxc_name_resource 'Microsoft.Storage/storageAccounts@2026-06-01' = {
  name: storageAccounts_clientxxxxxc_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
    client: 'clientc'
    dataClassification: 'confidential'
  }
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
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
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
}

resource virtualMachines_P5_VM_name_resource 'Microsoft.Compute/virtualMachines@2026-04-01' = {
  name: virtualMachines_P5_VM_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v6'
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
        name: '${virtualMachines_P5_VM_name}_OsDisk_1_accb7e8147cc46eb88593ea04286657c'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_P5_VM_name}_OsDisk_1_accb7e8147cc46eb88593ea04286657c'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_P5_VM_name
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
          id: networkInterfaces_p5_vm870_name_resource.id
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
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_clientxxxxxa 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'clientxxxxxa'
  properties: {
    metadata: {
      creator: 'created by private endpoint pe-clienta-blob with resource guid 00000000-0000-0000-0000-000000000000'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.50.1.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
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

resource storageAccounts_clientxxxxxa_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    changeFeed: {
      enabled: true
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
    isVersioningEnabled: true
  }
}

resource storageAccounts_clientxxxxxb_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxb_name_resource
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
    isVersioningEnabled: true
  }
}

resource storageAccounts_clientxxxxxc_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_resource
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
    isVersioningEnabled: true
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_clientxxxxxa_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_clientxxxxxb_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxb_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_clientxxxxxc_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_resource
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

resource storageAccounts_clientxxxxxa_name_storageAccounts_clientxxxxxa_name_13f276fe_0829_4814_be5a_eff52bf831d9 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
  name: '${storageAccounts_clientxxxxxa_name}.13f276fe-0829-4814-be5a-eff52bf831d9'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_clientxxxxxa_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_clientxxxxxb_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxb_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_clientxxxxxc_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_clientxxxxxa_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_clientxxxxxb_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxb_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_clientxxxxxc_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_mbxohzgwrt5pi 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'mbxohzgwrt5pi'
  location: 'global'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_p5_vnet_name_resource.id
    }
  }
}

resource privateEndpoints_pe_clienta_blob_name_resource 'Microsoft.Network/privateEndpoints@2025-09-01' = {
  name: privateEndpoints_pe_clienta_blob_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_pe_clienta_blob_name
        properties: {
          privateLinkServiceId: storageAccounts_clientxxxxxa_name_resource.id
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_pe_clienta_blob_name}-nic'
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_p5_vnet_name, 'snet-endpoints')
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
  }
}

resource privateEndpoints_pe_clienta_blob_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-09-01' = {
  parent: privateEndpoints_pe_clienta_blob_name_resource
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_blob_core_windows_net_name_resource.id
        }
      }
    ]
  }
}

resource storageAccounts_clientxxxxxa_name_default_rbactest 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_default
  name: 'rbactest'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_clientxxxxxa_name_resource
  ]
}

resource storageAccounts_clientxxxxxa_name_default_taxrecords 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_default
  name: 'taxrecords'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_clientxxxxxa_name_resource
  ]
}

resource storageAccounts_clientxxxxxc_name_default_taxrecords_replica 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_default
  name: 'taxrecords-replica'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_clientxxxxxc_name_resource
  ]
}

resource storageAccounts_clientxxxxxa_name_df32a999_e2df_449f_9e39_2f7b5a3e8c10 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2026-06-01' = {
  parent: storageAccounts_clientxxxxxa_name_resource
  name: 'df32a999-e2df-449f-9e39-2f7b5a3e8c10'
  properties: {
    metrics: {
      enabled: false
    }
    sourceAccount: storageAccounts_clientxxxxxa_name_resource.id
    destinationAccount: storageAccounts_clientxxxxxc_name_resource.id
    rules: [
      {
        ruleId: '040fe400-5b19-436e-9610-69bef9696284'
        sourceContainer: 'taxrecords'
        destinationContainer: 'taxrecords-replica'
        filters: {
          minCreationTime: '1601-01-01T00:00:00Z'
        }
      }
    ]
  }
}

resource storageAccounts_clientxxxxxc_name_df32a999_e2df_449f_9e39_2f7b5a3e8c10 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2026-06-01' = {
  parent: storageAccounts_clientxxxxxc_name_resource
  name: 'df32a999-e2df-449f-9e39-2f7b5a3e8c10'
  properties: {
    sourceAccount: storageAccounts_clientxxxxxa_name_resource.id
    destinationAccount: storageAccounts_clientxxxxxc_name_resource.id
    rules: [
      {
        ruleId: '040fe400-5b19-436e-9610-69bef9696284'
        sourceContainer: 'taxrecords'
        destinationContainer: 'taxrecords-replica'
        filters: {
          minCreationTime: '1601-01-01T00:00:00Z'
        }
      }
    ]
  }
}

resource networkInterfaces_p5_vm870_name_resource 'Microsoft.Network/networkInterfaces@2025-09-01' = {
  name: networkInterfaces_p5_vm870_name
  location: 'eastus'
  tags: {
    project: 'project_5'
    owner: 'lab-owner'
    expires: 'YYYY-MM-DD'
    environment: 'lab'
    purpose: 'az104-hands-on'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.50.2.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_P5_VM_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_p5_vnet_name, 'snet-vm')
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
    networkSecurityGroup: {
      id: networkSecurityGroups_P5_VM_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
