# Proof tests

Run these after deployment and after `listeners.sh` has been run on each VM.
Get the load balancer's public IP first: `az network public-ip show -g Project_3 -n pip-web-p3 --query ipAddress -o tsv`

> Tip: avoid `ping` in the portal's *Run command* box. Without `-c 1` it never ends and blocks the queue.

| # | Test | Run on | Command | Expected | Proves |
|---|------|--------|---------|----------|--------|
| 1 | Public load balancer rotates | your laptop | `seq 6 \| xargs -I{} curl -s -m 5 -w "\n" http://<LB-IP>` | Mixed `web-vm1` and `web-vm2` responses | Public LB + both web VMs healthy |
| 2 | Web can reach app through internal LB | web-vm1 | `curl -sS -m 5 -o /dev/null -w "%{http_code}\n" http://10.30.2.10:8080` | `200` | Rule `allow-web-to-app` + internal LB + probe |
| 3 | App can reach DB | vm-app | `timeout 3 bash -c '</dev/tcp/10.30.3.4/5432' && echo open` | `open` | Rule `allow-app-to-db` |
| 4 | Web cannot reach DB | web-vm1 | `timeout 3 bash -c '</dev/tcp/10.30.3.4/5432' && echo open \|\| echo blocked` | `blocked` | `Deny-Vnet` on nsg-db |
| 5 | VMs are not reachable from the internet | your laptop | `curl -m 5 http://10.30.1.4` | Times out (private IP) | VMs have no public IPs |
| 6 | Zone / VM failure | portal + laptop | Deallocate web-vm1, repeat test 1 | Only `web-vm2` answers, no errors | LB health probe removes the dead VM |
| 7 | Files allowed from app subnet | vm-app | `STORAGE_KEY='...' bash mount-files.sh <account>` | Share mounts | Service endpoint + storage firewall |
| 8 | Files refused elsewhere | web-vm2 | same command | `mount error(13): Permission denied` | Storage firewall allows only `snet_app` |
| 9 | Bastion access | portal | Connect > Bastion on each VM | SSH session opens | `allow-bastion` rules (10.30.4.0/26 to port 22) |
| 10 | DB listener | vm-db | `ss -tlnp \| grep 5432` | `LISTEN ... 0.0.0.0:5432` | Test listener is up |

Not run in the original lab (try them yourself): delete `Allow-LB` on nsg-app and watch the internal LB go unhealthy; add a blocking NSG rule and find it with *Effective security rules* or Network Watcher *IP flow verify*.
