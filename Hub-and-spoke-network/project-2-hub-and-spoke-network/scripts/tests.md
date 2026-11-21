# Proof tests

PowerShell on the VMs. Connect with Bastion, or use **VM > Operations > Run command > RunPowerShellScript**.
Run `scripts/allow-icmp.ps1` on every VM first, or every ping fails.

| # | Requirement | Test | Run on | Command | Expected |
|---|---|---|---|---|---|
| 1 | R1 | Plant A reaches plant B | vm-plantA-server | `Test-NetConnection 192.168.1.4` | `PingSucceeded : True` |
| 2 | R1 | The path goes through the hub NVA | vm-plantA-server | `tracert 192.168.1.4` | Hop 1 is `10.0.0.4` |
| 3 | R1 | Route is a user route to the appliance | portal | Network Watcher > Next hop (source 172.16.1.4, destination 192.168.1.4) | `VirtualAppliance`, `10.0.0.4` |
| 4 | R1 | Effective routes show the UDR winning | portal | NIC > Help > Effective routes | `192.168.0.0/16` User route, next hop 10.0.0.4, above the default `None` route |
| 5 | R2 | OT cannot reach the internet | vm-plantA-OT | `Test-NetConnection example.com -Port 443` | `TcpTestSucceeded : False` |
| 6 | R2 | The block is the NSG | portal | Network Watcher > IP flow verify (outbound, TCP, 172.16.2.4 to a public IP, port 443) | `Access denied`, rule `Deny-Internet-Out` |
| 7 | R2 | Server subnet has no NSG | portal | IP flow verify from 172.16.1.4 | "No NSG applied" message |
| 8 | R2 | Server subnet reaches the internet through the firewall | vm-plantA-server | `Test-NetConnection example.com -Port 443` | `TcpTestSucceeded : True` (only after the firewall and `to-internet` route exist) |
| 9 | R2 | OT still blocked with the firewall in place | vm-plantA-OT | same as 5 | `False` |
| 10 | R4 | Office reaches the hub over the VPN | vm-office | `Test-NetConnection 10.0.0.4` | `True` |
| 11 | R4 | Traffic crosses the tunnel, not the internet | vm-office | `tracert 10.0.0.4` | One hop |
| 12 | R4 | Gateway transit: office reaches plant A | vm-office | `Test-NetConnection 172.16.1.4` | `True` |
| 13 | R4 | Plant A reaches the office | vm-plantA-server | `Test-NetConnection 10.5.2.4` | `True` |
| 14 | R5 | Names resolve across all four networks | any VM | `Resolve-DnsName vm-plantb-serve.internal.dns` | `A` record `192.168.1.4` |
| 15 | R7 | Diagnose without logging in | portal | Network Watcher: Next hop, IP flow verify, Effective routes, Connection troubleshoot | See rows 3, 4, 6, 7 |

## Traps in the tests

- **Single-label names prove nothing.** `Resolve-DnsName vm-plantb-server` can answer from your own search suffix or cache. Test the full `name.internal.dns`.
- **Computer names are cut to 15 characters.** The DNS record for `vm-plantB-server` is `vm-plantb-serve`. Query that, or the lookup fails and looks like a DNS fault.
- **`example.com` is only a convenient public HTTPS site.** The test asks "is there a path to the internet on 443?", nothing more.
- **Ping fails until ICMP is allowed in Windows Firewall**, even when the routes are perfect.
- **IP flow verify checks NSGs only.** It says nothing about routes or the firewall. Use Next hop for routes.

## Optional hardening (block OT from the office)

By default nothing stops OT reaching the office over the VPN, because the `AllowVnetOutBound` default rule covers it. That is how the requirement "reach a head-office service on 443" is met in the final lab.

To prove an NSG can block it, add to `nsg-OT` outbound: `Block-access-to-officeVnet` at 2010 (any to 10.5.0.0/16). OT then fails to reach the office (images 42 and 43). The lab removed this rule afterwards, so the final build has only `Deny-Internet-Out`. To block everything except 443 you would add an Allow TCP 443 rule with a **lower** priority number (for example 2005) than the block; this variant was not built.
