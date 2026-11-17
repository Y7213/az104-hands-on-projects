# Proof tests (run, then screenshot the results — redact first, see docs/redaction-checklist.md)

Replace `<acct>` with your client A account name.

| # | Test | Command / action | Expected |
|---|------|------------------|----------|
| 1 | Public blocked | From your laptop (not in VNet, IP not allowed): `curl -s -o /dev/null -w "%{http_code}\n" "https://<acct>.blob.core.windows.net/taxrecords?restype=container&comp=list"` | 403 |
| 2 | Private DNS | On the VM: `nslookup <acct>.blob.core.windows.net` | Resolves to `10.50.1.x` via `privatelink` CNAME |
| 3 | Shared key off | Try `az storage blob list --account-name <acct> -c taxrecords --auth-mode key` | Error: key-based auth not permitted |
| 4 | RBAC data plane | Sign in as user with only Reader: list blobs | Denied; with Client Blob Editor: allowed |
| 5 | Delete safety | Delete a blob, then restore from soft-delete / previous version | Blob recovered |
| 6 | Replication | Upload to `taxrecords` on A | Appears in `taxrecords-replica` on C (can take minutes) |
| 7 | Logs | Run `queries.kql` in Log Analytics | Rows for your operations |
