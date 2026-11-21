# Project 2: Manufacturer Hub-and-Spoke Network

> Two plants, a head office and a hub. Plants talk only through the hub, the operational-technology (OT) subnets cannot reach the internet, head office joins over an encrypted VPN, names resolve everywhere, and faults are diagnosed from the portal without logging in to a VM. 
>
> 

![Architecture exported from the Azure resource visualizer](images/00-architecture-resource-visualizer.jpg)

![Resource group with the four VNets](images/01-resource-group-four-vnets.png)

| | |
|---|---|
| **Level** | Intermediate to advanced |
| **Time** | About 6 hours spread over two days (the VPN gateways take 30 to 45 minutes each) |
| **Region** | East US (all resources) |
| **Cost** | High if left running. Two VPN gateways and Azure Firewall bill by the hour. Build cheap parts first and delete the expensive ones as soon as you have proved them |
| **AZ-104 areas** | Virtual networking: peering, user-defined routes, NSGs, VPN gateway, private DNS, Azure Firewall, Network Watcher |

> [!WARNING]
> VPN gateways (`VpnGw2AZ`) and Azure Firewall are among the most expensive things in an AZ-104 lab. Follow [Teardown](#teardown) the same day.

---

## The scenario

A manufacturer runs two plants and a head office. Each plant has a server subnet and an OT subnet for machinery. Plants must never talk to each other directly. They go through the hub, where a virtual appliance can inspect the traffic. Machinery must not reach the internet at all, but must still be able to reach one head-office service on TCP 443. Head office connects to the hub over a VPN. Administrators use Bastion, and nothing has a public IP.

## Requirements and the evidence

| # | Requirement | Control used | Proven by |
|---|---|---|---|
| R1 | Plants cannot talk directly; traffic goes via the hub | Hub-and-spoke peering + route tables sending each plant's other-plant range to the NVA (`10.0.0.4`) + IP forwarding | Images 31, 32, 34, 36 |
| R2 | OT subnets have no outbound internet but can reach a head-office service on 443 | `nsg-OT` deny to `Internet`; private-by-default subnets; firewall rules list only the server subnets | Images 38, 39, 41, 62, 63. OT reaches the office because the default `AllowVnetOutBound` rule permits it. A temporary block rule proved an NSG can stop it (images 42, 43); it was removed afterwards |
| R3 | Admins connect only through Bastion, no public IPs | `AzureBastionSubnet` in the hub; VMs have no public IP | Subnet exists (image 05); Bastion itself was not rebuilt here, see [Project 3](../project-3-three-tier-erp/) |
| R4 | Head office connects to the hub over an encrypted VPN with private addressing | VNet-to-VNet connection (IKEv2, shared key) between `VPN-Hub` and `VPN-Office`; gateway transit towards plant A | Images 49, 50, 55, 56 |
| R5 | Internal names resolve across all networks | Private DNS zone `internal.dns` linked to all four VNets with auto-registration | Images 20, 21, 23 |
| R6 | Every flow can be explained from logs | **Not built.** NSG flow logs were skipped to save cost; Network Watcher on-demand tools were used instead | n/a |
| R7 | Diagnose faults without logging in to VMs | Network Watcher: Next hop, IP flow verify, Effective routes | Images 34 to 40 |

## Architecture

Exported from the Azure resource visualizer after the build. It shows the final state, including the orphan `ip-vpn` public IP.

![Architecture exported from the Azure resource visualizer](images/00-architecture-resource-visualizer.jpg)

The same design as a simplified diagram:

```mermaid
flowchart TB
  Office["Office-Vnet 10.5.0.0/16<br/>vm-office 10.5.2.4"]
  subgraph Hub["HUB-Vnet 10.0.0.0/16"]
    NVA["vm-NVA 10.0.0.4<br/>IP forwarding on"]
    FW["fw-hub (Azure Firewall)<br/>10.0.1.4"]
    VGH["VPN-Hub<br/>GatewaySubnet 10.0.3.0/24"]
    BAS["AzureBastionSubnet 10.0.2.0/26"]
  end
  subgraph A["plant_A_Vnet 172.16.0.0/16"]
    AS["snet-Server 172.16.1.0/24<br/>vm-plantA-server"]
    AO["snet-OT 172.16.2.0/24<br/>vm-plantA-OT + nsg-OT"]
  end
  subgraph B["plant_B_Vnet 192.168.0.0/16"]
    BS["snet-Server 192.168.1.0/24<br/>vm-plantB-server"]
    BO["snet-OT 192.168.2.0/24<br/>nsg-OT"]
  end
  Internet((Internet))
  A <-->|peering| Hub
  B <-->|peering| Hub
  AS -. "UDR 192.168.0.0/16 to NVA" .-> NVA
  BS -. "UDR 172.16.0.0/16 to NVA" .-> NVA
  AS -. "UDR 0.0.0.0/0 to firewall" .-> FW
  BS -. "UDR 0.0.0.0/0 to firewall" .-> FW
  FW --> Internet
  AO -. "no route out, NSG deny Internet" .-> Internet
  VGH <-->|"IPsec / IKEv2 tunnel"| VGO["VPN-Office<br/>GatewaySubnet 10.5.1.0/24"]
  VGO --- Office
```

### Address plan

| VNet | Range | Subnets |
|---|---|---|
| `HUB-Vnet` | 10.0.0.0/16 | `NVA-Subnet` 10.0.0.0/24, `AzureFirewallSubnet` 10.0.1.0/26, `AzureBastionSubnet` 10.0.2.0/26, `GatewaySubnet` 10.0.3.0/24 |
| `plant_A_Vnet` | 172.16.0.0/16 | `snet-Server` 172.16.1.0/24, `snet-OT` 172.16.2.0/24 |
| `plant_B_Vnet` | 192.168.0.0/16 | `snet-Server` 192.168.1.0/24, `snet-OT` 192.168.2.0/24 |
| `Office-Vnet` | 10.5.0.0/16 | `GatewaySubnet` 10.5.1.0/24, `snet-office` 10.5.2.0/24 |

The four ranges must not overlap. Peering and VPN both refuse overlapping address spaces. Azure reserves the first four addresses of each subnet, so the first VM is `.4`.

## Why each piece exists

**Peering is not transitive.** Plant A and plant B are each peered to the hub, but that does not let A reach B. Azure's built-in routes for the private ranges (`10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) point to *None*, so traffic to the other plant is dropped. Three things together make the hub relay it:

| Piece | What it does | If you forget it |
|---|---|---|
| User-defined route on the plant subnets (`192.168.0.0/16` to `10.0.0.4`, `VirtualAppliance`) | Overrides the built-in drop route. A user route beats BGP, which beats system routes | Packets are dropped; ping times out |
| **Enable IP forwarding** on the NVA NIC **and** forwarding inside Windows | Azure delivers packets not addressed to the NVA, and Windows routes them instead of discarding them | Packets reach the NVA and stop there |
| **Allow forwarded traffic** on the plant-side peerings | The plant accepts packets that originated elsewhere and arrive relayed by the hub | The reply is dropped on the way back |

Route tables attach to **subnets**, not VNets. Do not put an NSG or route table on `NVA-Subnet`, or you create a routing loop.

**Private by default.** New subnets no longer give VMs free outbound internet (default outbound access is retired, verify the date on Microsoft Learn). A VM with no public IP has no internet until you add a firewall, NAT gateway or public IP. That is why the server subnets needed the firewall, and why OT needed only an explicit NSG deny as a second layer.

**Centralised egress.** A `0.0.0.0/0` route to the firewall's private IP sends all internet traffic through the hub. This is *not* forced tunnelling (that sends internet traffic back to on-premises and needs a firewall management NIC and subnet).

**Gateway transit.** The hub's gateway can serve the spokes. The hub-side peering must have *allow gateway transit* saved **before** the spoke-side peering can tick *use remote gateway*. Only plant A was given transit in this lab. With transit, the office reached plant A through the tunnel without BGP.

**Private DNS.** One zone, four virtual-network links with auto-registration. VMs register themselves using their computer name, which Windows limits to 15 characters.

## Templates

[`template/`](template/) holds the three files exactly as the Azure portal exported them from the finished lab. They are unedited.

| File | Tool |
|---|---|
| `hub-and-spoke_network.bicep` | Azure CLI (Bicep) |
| `hub-and-spoke_network.json` | ARM template, Azure CLI / portal |
| `hub-and-spoke_network.tf` | Terraform |

> [!NOTE]
> These are raw exports of the final state, **not** cleaned or test-deployed. Expect to fix things before they deploy: exports contain duplicated resources, read-only values (such as the public IP addresses and the original subscription and resource IDs), no passwords or VPN shared key, and no in-guest setup. They are a record of what the lab looked like, not a ready-to-run deployment. The final state also matches the lab as it ended: `rt-plantB` has no `to-internet` route and `nsg-OT` has only `Deny-Internet-Out`.

The in-guest commands the lab ran by hand are in [`scripts/nva-forwarding.ps1`](scripts/nva-forwarding.ps1) and [`scripts/allow-icmp.ps1`](scripts/allow-icmp.ps1). [`scripts/teardown.sh`](scripts/teardown.sh) deletes the expensive parts first.

## Build order and why

| Step | Do this | Why it comes here |
|---|---|---|
| 1 | Create the resource group and four VNets with non-overlapping ranges | Peering and VPN reject overlaps, and ranges cannot be edited easily once peered |
| 2 | Add the gateway, firewall and Bastion subnets with their **exact** names | Azure services look for `GatewaySubnet`, `AzureFirewallSubnet`, `AzureBastionSubnet` by name |
| 3 | Peer plants to the hub (forwarded traffic ticked on the plant side only) | Routing needs the peerings first |
| 4 | Create `nsg-OT` and attach it to both OT subnets | Cheap, and gives you something to test with IP flow verify |
| 5 | Create the Private DNS zone and four links | Free, and the VMs register themselves when they are created |
| 6 | Deploy the five VMs with no public IPs; set the NVA NIC to static `10.0.0.4` | The route table needs a fixed next-hop address |
| 7 | Enable IP forwarding on the NVA NIC and in Windows | Without both, relayed packets are dropped |
| 8 | Create the two route tables and **attach them to the subnets** | A route table that is not attached does nothing |
| 9 | Test A to B, then use Network Watcher to prove it | Proves R1 and R7 before spending money |
| 10 | Create the VPN gateways (wait 30 to 45 minutes each), then the two connections | Slowest and costliest step; do it once the free parts work |
| 11 | Hub peering: allow gateway transit, **save**; then plant A peering: use remote gateway | The spoke setting fails without the hub setting |
| 12 | Create the firewall (policy, no management NIC, NAT gateway option unticked) and the `0.0.0.0/0` routes | Last, because it is the most expensive |

## Prove it

Full commands and expected output are in [`scripts/tests.md`](scripts/tests.md). The short version:

| Test | Expected |
|---|---|
| Plant A server pings plant B server | Succeeds; `tracert` shows `10.0.0.4` as hop 1 |
| Network Watcher Next hop, plant A to plant B | `VirtualAppliance 10.0.0.4` |
| OT VM opens `example.com` on 443 | `False` |
| IP flow verify from OT to the internet | Denied by `Deny-Internet-Out` |
| Server subnet opens `example.com` on 443 after the firewall | `True` |
| Office VM pings the hub and plant A | Succeeds over the VPN |
| `Resolve-DnsName vm-plantb-serve.internal.dns` from any VM | `192.168.1.4` |

## Screenshots

Subscription IDs, tenant names, emails and resource IDs are redacted. Images are numbered in build order.

**Networks and addressing**

![Resource group with the four VNets](images/01-resource-group-four-vnets.png)
![Hub VNet address space and subnets](images/02-hub-vnet-address-space-and-subnets.png)
![Plant A VNet address space](images/03-plant-a-vnet-address-space.png)
![Plant B VNet address space](images/04-plant-b-vnet-address-space.png)
![Hub subnets](images/05-hub-vnet-subnets.png)
![Plant A subnets](images/07-plant-a-vnet-subnets.png)
![Plant B subnets](images/08-plant-b-vnet-subnets.png)
![Office subnets](images/06-office-vnet-subnets.png)

**Peering (R1)**

![Adding the plant A side of the peering](images/10-add-peering-plant-a-side.png)
![Hub side, forwarded traffic unticked](images/11-add-peering-hub-side-forwarded-traffic-unticked.png)
![Hub to plant A settings](images/13-peering-hub-to-plant-a-settings.png)
![Hub to plant B settings](images/14-peering-hub-to-plant-b-settings.png)
![Hub peerings Connected](images/15-hub-vnet-peerings-connected.png)
![Plant A peerings](images/16-plant-a-vnet-peerings-connected.png)
![Plant B peerings](images/17-plant-b-vnet-peerings-connected.png)

**NSG for the OT subnets (R2)**

![nsg-OT default rules before](images/18-nsg-ot-default-rules-before.png)
![nsg-OT associated to both OT subnets](images/19-nsg-ot-associated-to-both-ot-subnets.png)

**Private DNS (R5)**

![Zone linked to four VNets](images/20-private-dns-zone-four-vnet-links.png)
![Auto-registered records](images/21-private-dns-zone-recordsets-auto-registered.png)
![Single-label query is not proof](images/22-dns-single-label-query-not-proof.png)
![FQDN query answered from the zone](images/23-dns-fqdn-query-answer-from-zone.png)

**Routing through the NVA (R1)**

![Create route table](images/24-create-route-table-rt-plant-a.png)
![rt-plantA route to plant B](images/25-rt-plant-a-route-to-plant-b.png)
![rt-plantB route to plant A](images/26-rt-plant-b-route-to-plant-a.png)
![Five VMs, no public IP](images/27-five-vms-running-no-public-ip.png)
![NVA overview, static IP](images/28-vm-nva-overview-static-ip.png)
![rt-plantA attached to both subnets](images/29-rt-plant-a-attached-to-both-subnets.png)
![rt-plantB attached to both subnets](images/30-rt-plant-b-attached-to-both-subnets.png)
![Plant A to plant B ping](images/31-plant-a-to-plant-b-ping-after-routes.png)
![tracert via the NVA](images/32-tracert-plant-a-to-plant-b-via-nva.png)
![OT to plant B](images/33-ot-to-plant-b-ping-and-tracert.png)
![Next hop: virtual appliance](images/34-next-hop-virtual-appliance.png)
![Effective routes](images/35-effective-routes-top.png)
![Effective routes: user route wins](images/36-effective-routes-user-route-wins.png)

**Network Watcher diagnostics (R2, R7)**

![Next hop from OT to internet](images/37-next-hop-ot-to-internet-system-route.png)
![IP flow verify: denied by nsg-OT](images/38-ip-flow-verify-ot-denied-by-nsg-ot.png)
![IP flow verify: no NSG on server subnet](images/39-ip-flow-verify-no-nsg-on-server-subnet.png)
![Next hop to internet before the firewall](images/40-next-hop-server-to-internet-before-firewall.png)
![No internet from the plant before the firewall](images/41-no-internet-from-plant-before-firewall.png)
![Optional rule blocking OT from the office](images/42-optional-nsg-rule-block-office-from-ot.png)
![OT to office blocked after the rule](images/43-optional-ot-to-office-blocked-after-rule.png)

**VPN (R4)**

![Gateways created](images/44-vpn-gateways-created.png)
![Create connection, basics](images/45-vpn-create-connection-basics.png)
![Create connection, settings](images/46-vpn-create-connection-settings.png)
![Connections, status Unknown](images/47-vpn-connections-created-status-unknown.png)
![Office to hub ping over the VPN](images/49-office-to-hub-ping-over-vpn.png)
![tracert: single hop](images/50-office-to-hub-tracert-single-hop.png)
![Hub side: allow gateway transit](images/53-hub-side-allow-gateway-transit.png)
![Plant A side: use remote gateway](images/54-plant-a-side-use-remote-gateway.png)
![Office to plant A over the VPN](images/55-office-to-plant-a-ping-over-vpn-and-transit.png)
![Plant A to office](images/56-plant-a-to-office-ping-and-tracert.png)

**Azure Firewall (R2)**

![NAT gateway option left unticked](images/57-firewall-advanced-nat-gateway-option-unticked.png)
![Firewall overview and private IP](images/59-firewall-overview-private-ip.png)
![Firewall policy](images/60-firewall-policy-overview.png)
![Network rule](images/61-firewall-policy-network-rule.png)
![Plant A server reaches the internet through the firewall](images/62-plant-a-server-reaches-internet-through-firewall.png)
![OT still blocked](images/63-ot-still-blocked-from-internet.png)

**Mistakes worth seeing**

![Plant B VNet in the wrong resource group](images/09-mistake-plant-b-vnet-created-in-wrong-resource-group.png)
![Forwarded traffic ticked on the hub side](images/12-mistake-forwarded-traffic-ticked-on-hub-side.png)
![No connection after the first attempt](images/48-mistake-no-connection-after-first-attempt.png)
![Gateway transit order error](images/51-mistake-gateway-transit-order-error.png)
![Wrong gateway checkbox on the spoke](images/52-mistake-wrong-gateway-checkbox-on-spoke.png)
![Firewall management NIC error](images/58-mistake-firewall-management-nic-error.png)

## Things that went wrong (and the fix)

| Symptom | Cause | Fix |
|---|---|---|
| Plant A cannot reach plant B | Built-in route for `192.168.0.0/16` is *None*; no route to the NVA | Add the UDR and **attach the route table to the subnets** |
| Packets reach the NVA but go no further | Forwarding enabled in Azure only | Also enable it in Windows (`scripts/nva-forwarding.ps1`) |
| Ping fails but routes look right | Windows Firewall blocks ICMP echo | Run `scripts/allow-icmp.ps1` |
| A VNet ended up in another resource group | Wrong group chosen in the wizard (image 09) | Delete and recreate in `Project_2`; VNets cannot be moved between peering partners freely |
| Hub peering has forwarded traffic ticked | Ticked on both sides (image 12) | Tick it on the plant side only |
| Gateway transit error when saving the spoke | Hub side was not saved first (image 51) | Save the hub side, then the spoke |
| Spoke peering error about gateways | Ticked *allow gateway in this VNet* on a spoke that has no gateway (image 52) | Spoke uses only *use remote gateway* |
| Firewall wizard: "Force Tunneling requires AzureFirewallManagementSubnet" | Management NIC ticked (image 58) | Untick it, or add the management subnet and second public IP |
| VPN gateway sits in *Updating* for 30 minutes | Normal | Wait; do not delete during the update |
| Connection list empty after creating it | First attempt did not complete (image 48) | Recreate it after the gateway shows Succeeded |
| `Resolve-DnsName` fails for a long VM name | Computer name cut to 15 characters | Query `vm-plantb-serve`, not `vm-plantb-server` |
| Single-label DNS query "works" | Search suffix or cache, not the zone (image 22) | Test the FQDN |
| `example.com` fails from a server VM before the firewall | Subnet has no outbound access by default | Add firewall and route; not a bug |

## Not done in this lab

- **Bastion** was not rebuilt (done in Project 3).
- **NSG flow logs and Traffic Analytics** (R6) were skipped for cost.
- **BGP** was not used; the tunnel is static.
- **Plant B has no OT VM.** Only plant A's OT subnet was tested; plant B's OT subnet has the same NSG attached.
- **Plant B internet egress was not tested.** The `to-internet` route was proven for plant A. Plant B has no `to-internet` route in the final lab.
- The temporary NSG rules used for testing (block office, and an allow for 443) were deleted afterwards, so the final `nsg-OT` has only the deny rule.

## Cost notes

| Resource | Bills while it exists |
|---|---|
| 2 VPN gateways (`VpnGw2AZ`) + 2 public IPs | Yes, hourly. The biggest cost |
| Azure Firewall Standard + public IP | Yes, hourly |
| 5 small VMs | Yes, until deallocated (template sets a daily auto-shutdown) |
| Peering | Per GB transferred |
| Private DNS zone | Small |

## Teardown

1. Delete the two VPN connections, then the firewall and `pip-fw-hub` (the most expensive per hour).
2. Delete both VPN gateways (this takes a while) and any leftover public IPs.
3. Delete the resource group `Project_2`, or run [`scripts/teardown.sh`](scripts/teardown.sh).
4. Check Cost Management the next day.

## AZ-104 mapping

- **Networking:** VNet peering and its non-transitivity, system routes vs user-defined routes, next hop types, NSG priorities and service tags, VPN gateway and gateway transit, Private DNS zones and links, Azure Firewall, Network Watcher tools
- **Compute:** VM NICs, IP forwarding, static private IPs
- **Monitor and maintain:** Network Watcher diagnostics

> Unofficial study material. Not affiliated with or endorsed by Microsoft.
