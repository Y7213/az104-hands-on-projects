// Project 5 governance pieces that live at SUBSCRIPTION scope:
//   1. a custom RBAC role (data-plane blob read/write/delete, no key listing)
//   2. an Azure Policy initiative (policy set) for storage hygiene, assigned to one resource group
//
// Deploy: az deployment sub create -l eastus -f subscription-governance.bicep -p targetResourceGroup=Project_5
targetScope = 'subscription'

param targetResourceGroup string = 'Project_5'

resource role 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Client Blob Editor')
  properties: {
    roleName: 'Client Blob Editor'
    description: 'Read, write and delete blobs. Cannot list account keys or change the account.'
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Storage/storageAccounts/blobServices/containers/read'
        ]
        dataActions: [
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'
          'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'
        ]
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

@description('Extra built-in policy definition ids to add (e.g. "Storage accounts should disable public network access"). Look the GUIDs up in Portal > Policy > Definitions; they are not hard-coded here because they must be verified per tenant/cloud.')
param extraPolicyDefinitionIds array = []

var policyIds = concat([
  // Secure transfer to storage accounts should be enabled
  '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
], extraPolicyDefinitionIds)

resource initiative 'Microsoft.Authorization/policySetDefinitions@2025-01-01' = {
  name: 'p5-storage-hygiene'
  properties: {
    displayName: 'Project 5 - storage hygiene'
    policyType: 'Custom'
    policyDefinitions: [for (id, i) in policyIds: {
      policyDefinitionReferenceId: 'ref${i}'
      policyDefinitionId: id
    }]
  }
}

// Scope the assignment to one resource group; use Audit effect first to see impact.
module assign 'assign-initiative.bicep' = {
  name: 'assign-p5-initiative'
  scope: resourceGroup(targetResourceGroup)
  params: {
    initiativeId: initiative.id
  }
}
