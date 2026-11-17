using 'main.bicep'

// Copy to main.local.bicepparam (git-ignored) for real values.
param ownerTag = 'your-handle'
param expiresTag = '2026-12-31'      // delete-by date, YYYY-MM-DD
param deployTestVm = true
param testVmPublicIp = false          // use Azure Bastion instead of RDP over the internet
param allowedClientIp = ''            // your public IP if you need portal access, else leave empty
param adminPassword = readEnvironmentVariable('P5_VM_PASSWORD', '')   // never hard-code

// Second pass only (after first deploy, copy the two outputs here):
// param replicationPolicyId = '<output replicationPolicyId>'
// param replicationRuleId   = '<output replicationRuleId>'
