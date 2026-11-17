targetScope = 'resourceGroup'
param initiativeId string

resource assignment 'Microsoft.Authorization/policyAssignments@2025-01-01' = {
  name: 'p5-storage-hygiene'
  properties: {
    displayName: 'Project 5 - storage hygiene'
    policyDefinitionId: initiativeId
    enforcementMode: 'Default'
  }
}
