# Redaction checklist (do this BEFORE every commit and every screenshot)

Deleting resources kills credentials, but identity data stays valid and stays in git history forever.

**Never commit:** storage account keys, SAS tokens or URLs (`?sv=...&sig=...`), connection strings, VM passwords, service principal secrets, `.env` files, exported `.publishsettings`.

**Scrub from text, JSON, Bicep, logs:**
- [ ] Subscription ID, tenant ID, object IDs
- [ ] Your email / UPN / real name in `owner` tags
- [ ] Your home/office public IP (storage `ipRules`, NSG rules, KQL output `CallerIpAddress`)
- [ ] Public IPs of VMs and load balancers
- [ ] Real storage account names if you want no link back to you

**Screenshots:** blur or crop the top-right account menu, subscription/tenant fields, the portal URL bar, IP addresses, SAS URLs, anything under *Access keys*.

**Before pushing:**
```
git ls-files | xargs grep -n -E "sig=|AccountKey=|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
```
Review each hit. If a secret ever reached a commit, rotating it is not enough for IDs: rewrite history (`git filter-repo`) or start a fresh repo.
