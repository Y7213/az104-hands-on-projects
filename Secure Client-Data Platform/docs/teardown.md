# Teardown (general)

1. Check for locks and retention that block deletion: resource locks, **unlocked** immutability policies (remove first; a *locked* one cannot be removed), Recovery Services vault soft delete.
2. Delete the resource group: `az group delete -n <rg> --yes --no-wait`.
3. Confirm: `az group exists -n <rg>` returns `false`.
4. Sub-scope leftovers are NOT in the resource group. Delete them separately:
   - custom role: `az role definition delete --name "Client Blob Editor"`
   - policy assignment/initiative: Portal > Policy > Assignments / Definitions
5. Check Cost Management the next day.
