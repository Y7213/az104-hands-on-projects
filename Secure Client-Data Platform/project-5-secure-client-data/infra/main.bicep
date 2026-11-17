// Project 5: secure client-data platform (resource-group scope)
//
// Deploys: VNet + 2 subnets, private DNS zone, three client storage accounts
// (shared key off, public blob access off, TLS 1.2, versioning, soft delete),
// a private endpoint for client A, object replication A -> C, a lifecycle rule,
// a Log Analytics workspace with blob diagnostic settings, and (optionally) a
// small Windows test VM inside the VNet.
//
// Deploy:  az deployment group create -g Project_5 -f main.bicep -p main.bicepparam
// Prereq:  the resource group already exists.
//
// Names of storage accounts must be globally unique, so a short hash of the
// resource group id is appended automatically.

targetScope = 'resourceGroup'

// ---------- Parameters ----------
@description('Azure region. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Tag values applied to every taggable resource.')
param projectTag string = 'project_5'
param ownerTag string = 'lab-owner'
@description('Date after which the lab should be deleted, YYYY-MM-DD. Used by your own clean-up sweeps.')
param expiresTag string = 'YYYY-MM-DD'
param environmentTag string = 'lab'

@description('Client short names. One storage account per client = one cost-allocation boundary.')
param clients array = [
  'clienta'
  'clientb'
  'clientc'
]

@description('Public network access on the storage accounts. Keep Disabled once the private endpoint works.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional: your public IP (a single address) allowed through the storage firewall, for portal access. Leave empty for none.')
param allowedClientIp string = ''

@description('Deploy the small Windows test VM used to prove private access.')
param deployTestVm bool = true

@description('Give the test VM a public IP (for RDP). Default false: use Azure Bastion instead.')
param testVmPublicIp bool = false

@description('If the VM has a public IP, the single address allowed to RDP in. Never use * here.')
param rdpSourceAddress string = ''

@description('Second pass only: policy id returned by the destination (output replicationPolicyId).')
param replicationPolicyId string = ''
@description('Second pass only: rule id returned by the destination (output replicationRuleId).')
param replicationRuleId string = ''

param adminUsername string = 'azureuser'

@secure()
@description('Test VM admin password. Required when deployTestVm is true. Never commit a real value.')
param adminPassword string = ''

@description('VM size. Check availability in your region and quota before deploying.')
param vmSize string = 'Standard_B2s'

@description('Retention for blob/container soft delete, in days.')
@minValue(1)
@maxValue(365)
param softDeleteDays int = 7

@description('Create an UNLOCKED time-based retention policy on the taxrecords container. Leave false in a lab you plan to delete: retention blocks deletion until it is removed.')
param enableImmutability bool = false

@description('Retention period for the immutability policy, in days.')
param immutabilityDays int = 1

// ---------- Variables ----------
var tags = {
  project: projectTag
  owner: ownerTag
  expires: expiresTag
  environment: environmentTag
  purpose: 'az104-hands-on'
}

var hash = take(uniqueString(resourceGroup().id), 6)
var vnetName = 'p5-vnet'
var snetEndpoints = 'snet-endpoints'
var snetVm = 'snet-vm'
var dnsZoneName = 'privatelink.blob.${environment().suffixes.storage}'
var workspaceName = 'project5-logs'
var peName = 'pe-${clients[0]}-blob'

var hasClientIp = !empty(allowedClientIp)

// ---------- Networking ----------
resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.50.0.0/16'
      ]
    }
    subnets: [
      {
        name: snetEndpoints
        properties: {
          addressPrefix: '10.50.1.0/24'
          privateEndpointNetworkPolicies: 'Disabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: snetVm
        properties: {
          addressPrefix: '10.50.2.0/24'
          defaultOutboundAccess: false
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: vmNsg.id
          }
        }
      }
    ]
  }
}

resource vmNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'p5-vm-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: (testVmPublicIp && !empty(rdpSourceAddress)) ? [
      {
        name: 'allow-rdp-from-admin'
        properties: {
          priority: 300
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: rdpSourceAddress
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
        }
      }
    ] : []
  }
}

// ---------- Private DNS ----------
resource dnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneName
  location: 'global'
  tags: tags
}

// The link is at VNet level, not subnet level: every subnet in the VNet resolves the zone.
resource dnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dnsZone
  name: '${vnetName}-link'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// ---------- Storage ----------
resource accounts 'Microsoft.Storage/storageAccounts@2024-01-01' = [for c in clients: {
  name: take('${c}${hash}${uniqueString(resourceGroup().id, c)}', 24)
  location: location
  tags: union(tags, {
    client: c
    dataClassification: 'confidential'
  })
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    allowCrossTenantReplication: false
    defaultToOAuthAuthentication: true
    publicNetworkAccess: publicNetworkAccess
    accessTier: 'Hot'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: hasClientIp ? [
        {
          value: allowedClientIp
          action: 'Allow'
        }
      ] : []
    }
  }
}]

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = [for (c, i) in clients: {
  parent: accounts[i]
  name: 'default'
  properties: {
    isVersioningEnabled: true
    // Change feed is required on the replication SOURCE account (client A).
    changeFeed: {
      enabled: true
    }
    deleteRetentionPolicy: {
      enabled: true
      days: softDeleteDays
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: softDeleteDays
    }
  }
}]

// Client A holds the records and the RBAC test container; client C holds the replica.
resource taxrecords 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: blobServices[0]
  name: 'taxrecords'
  properties: {
    publicAccess: 'None'
  }
}

resource rbactest 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: blobServices[0]
  name: 'rbactest'
  properties: {
    publicAccess: 'None'
  }
}

resource replica 'Microsoft.Storage/storageAccounts/blobServices/containers@2024-01-01' = {
  parent: blobServices[2]
  name: 'taxrecords-replica'
  properties: {
    publicAccess: 'None'
  }
}

// UNLOCKED time-based retention. Locking is a separate, irreversible action: do not lock in a lab.
resource immutability 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2024-01-01' = if (enableImmutability) {
  parent: taxrecords
  name: 'default'
  properties: {
    immutabilityPeriodSinceCreationInDays: immutabilityDays
    allowProtectedAppendWrites: false
  }
}

// ---------- Object replication: client A (source) -> client C (destination) ----------
// Order matters: create the policy on the DESTINATION first (name 'default'), then on the
// source using the policy id and rule id that the destination returned.
resource replicationDest 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2024-01-01' = {
  parent: accounts[2]
  name: 'default'
  dependsOn: [
    blobServices
  ]
  properties: {
    sourceAccount: accounts[0].id
    destinationAccount: accounts[2].id
    rules: [
      {
        sourceContainer: taxrecords.name
        destinationContainer: replica.name
      }
    ]
  }
}

// Second pass: the source-side policy must be NAMED with the policy id returned by the
// destination, and Bicep requires resource names to be known at the start of deployment.
// So: deploy once, read output replicationPolicyId / replicationRuleId, then redeploy with
// those two values set in main.bicepparam. (Or use `az storage account or-policy create`.)
resource replicationSource 'Microsoft.Storage/storageAccounts/objectReplicationPolicies@2024-01-01' = if (!empty(replicationPolicyId)) {
  parent: accounts[0]
  name: replicationPolicyId
  properties: {
    sourceAccount: accounts[0].id
    destinationAccount: accounts[2].id
    rules: [
      {
        ruleId: replicationRuleId
        sourceContainer: taxrecords.name
        destinationContainer: replica.name
      }
    ]
  }
}

// ---------- Lifecycle management (example rule, client A) ----------
// Tiers move on days since LAST MODIFICATION. Rules can take up to ~24 h to start acting.
resource lifecycle 'Microsoft.Storage/storageAccounts/managementPolicies@2024-01-01' = {
  parent: accounts[0]
  name: 'default'
  dependsOn: [
    blobServices
  ]
  properties: {
    policy: {
      rules: [
        {
          name: 'age-out-taxrecords'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: {
              blobTypes: [
                'blockBlob'
              ]
              prefixMatch: [
                'taxrecords/'
              ]
            }
            actions: {
              baseBlob: {
                tierToCool: {
                  daysAfterModificationGreaterThan: 30
                }
                tierToArchive: {
                  daysAfterModificationGreaterThan: 180
                }
                delete: {
                  daysAfterModificationGreaterThan: 2555
                }
              }
            }
          }
        }
      ]
    }
  }
}

// ---------- Private endpoint for client A's blob endpoint ----------
resource pe 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: peName
  location: location
  tags: tags
  properties: {
    subnet: {
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, snetEndpoints)
    }
    privateLinkServiceConnections: [
      {
        name: peName
        properties: {
          privateLinkServiceId: accounts[0].id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

resource peDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  parent: pe
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob'
        properties: {
          privateDnsZoneId: dnsZone.id
        }
      }
    ]
  }
}

// ---------- Logging ----------
resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Resource logs (data plane) go to the workspace: StorageBlobLogs table.
resource blobDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: blobServices[0]
  name: 'to-log-analytics'
  properties: {
    workspaceId: workspace.id
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
  }
}

// ---------- Optional test VM inside the VNet ----------
resource vmPip 'Microsoft.Network/publicIPAddresses@2024-05-01' = if (deployTestVm && testVmPublicIp) {
  name: 'p5-vm-ip'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2024-05-01' = if (deployTestVm) {
  name: 'p5-vm-nic'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, snetVm)
          }
          publicIPAddress: testVmPublicIp ? {
            id: vmPip.id
          } : null
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = if (deployTestVm) {
  name: 'P5-VM'
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    osProfile: {
      computerName: 'P5-VM'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}

// ---------- Outputs ----------
output storageAccountNames array = [for (c, i) in clients: accounts[i].name]
output clientABlobEndpoint string = accounts[0].properties.primaryEndpoints.blob
output privateDnsZone string = dnsZone.name
output workspaceId string = workspace.id
output replicationPolicyId string = replicationDest.properties.policyId
output replicationRuleId string = replicationDest.properties.rules[0].ruleId
