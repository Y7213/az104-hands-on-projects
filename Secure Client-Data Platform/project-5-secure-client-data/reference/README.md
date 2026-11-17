# Reference exports

Sanitised exports of the lab as originally built in the portal.
- Home IP and VM public IP replaced/removed, owner tag genericised, ~740 Log Analytics table/saved-search entries stripped, tags harmonised.
- Not included by Azure's export: lifecycle policy, diagnostic settings, role assignments, custom role, policy initiative. Use `../infra/` for those.
- Exports are snapshots; prefer `../infra/main.bicep` for redeploying. No passwords are in these files; set the VM password yourself.
