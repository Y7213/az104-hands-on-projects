# Project 3: Three-Tier Law-Firm ERP

> A web, app and database tier inside one virtual network, locked down so each tier can only talk to the next, with load balancers in front, shared files, private admin access and a backup.

![Architecture exported from the Azure resource visualizer](images/01-architecture-resource-visualizer.png)

| | |
|---|---|
| **Level** | Intermediate |
| **Time** | About 3 hours to build, 1 hour to test |
| **Region** | East US (all resources) |
| **Cost** | Moderate. VMs, Bastion and the NAT gateway bill by the hour, so build, test and delete in one sitting |
| **AZ-104 areas** | Virtual networking, compute, storage, monitor and maintain (backup) |

> [!WARNING]
> Bastion, the NAT gateway and four VMs cost money while they exist. Follow [Teardown](#teardown) as soon as you finish.

---

## The scenario

A law firm is moving its case-management ERP to Azure. Staff reach the web site from the internet. The web tier calls an app tier. The app tier talks to a database. Nobody should be able to skip a tier, and administrators must reach the servers without any VM having a public IP address.

## Requirements and how each is met

| # | Requirement | Control used |
|---|---|---|
| R1 | Only the web tier is reachable from the internet, on port 80 | Public load balancer + `allow-http` rule on **nsg-web** |
| R2 | The app tier accepts traffic only from the web tier, on 8080 | **Application security groups** (ASGs) + `allow-web-to-app` |
| R3 | The database accepts traffic only from the app tier, on 5432 | ASGs + `allow-app-to-db` |
| R4 | Everything else inside the network is blocked | Explicit `Deny-Vnet` rules (priority below the defaults) |
| R5 | Administrators connect without public IPs on the VMs | **Azure Bastion** + `allow-bastion` rules |
| R6 | The web tier survives the loss of a VM or zone | Two web VMs in different **availability zones** behind the load balancer |
| R7 | The app tier is load balanced internally, with health checks | **Internal load balancer** + health probe |
| R8 | Shared case files are reachable only from the app subnet | **Azure Files** + storage firewall + **service endpoint** |
| R9 | The database VM is backed up | **Recovery Services vault** + backup policy |
| R10 | App VMs can reach the internet outbound without public IPs | **NAT gateway** on the app subnet |

## Architecture

```mermaid
flowchart TB
  Internet((Internet))
  Admin((Admin))
  subgraph VNet["P3_Vnet 10.30.0.0/16"]
    direction TB
    subgraph Web["snet_web 10.30.1.0/24 (nsg-web)"]
      W1["web-vm1<br/>zone 1<br/>10.30.1.4"]
      W2["web-vm2<br/>zone 2<br/>10.30.1.5"]
    end
    subgraph App["snet_app 10.30.2.0/24 (nsg-app)"]
      ILB["internal-lb<br/>10.30.2.10:8080"]
      A["vm-app<br/>zone 2<br/>10.30.2.4"]
    end
    subgraph Db["snet_db 10.30.3.0/24 (nsg-db)"]
      D["vm-db<br/>zone 1<br/>10.30.3.4:5432"]
    end
    Bas["AzureBastionSubnet 10.30.4.0/26<br/>Bastion"]
    NAT["NAT gateway"]
  end
  PLB["Public load balancer plb-p3<br/>port 80"]
  Files[("Azure Files<br/>casefiles")]
  Vault["Recovery Services vault<br/>vm-db-backup"]
  Internet --> PLB --> W1 & W2
  W1 & W2 -->|8080| ILB --> A
  A -->|5432| D
  A -. service endpoint .-> Files
  Admin --> Bas -->|SSH 22| W1 & W2 & A & D
  A --- NAT --> Internet
  D -. backup .-> Vault
```

### Address plan

| Subnet | CIDR | Holds | NSG |
|---|---|---|---|
| `snet_web` | 10.30.1.0/24 | web-vm1 (.4), web-vm2 (.5) | nsg-web |
| `snet_app` | 10.30.2.0/24 | vm-app (.4), internal-lb frontend (.10) | nsg-app |
| `snet_db` | 10.30.3.0/24 | vm-db (.4) | nsg-db |
| `AzureBastionSubnet` | 10.30.4.0/26 | Bastion (name and /26 or larger are required) | none |

> Azure reserves the first four addresses in every subnet, which is why the first VM is always `.4`.

### Security rules

Rules are checked lowest priority number first, and the first match wins.

| NSG | Priority | Name | From | To | Port | Action |
|---|---|---|---|---|---|---|
| nsg-web | 100 | `allow-http` | Internet | asg-web | 80 | Allow |
| nsg-web | 120 | `allow-bastion` | 10.30.4.0/26 | asg-web | 22 | Allow |
| nsg-app | 100 | `allow-web-to-app` | asg-web | asg-app | 8080 | Allow |
| nsg-app | 120 | `allow-bastion-app` | 10.30.4.0/26 | asg-app | 22 | Allow |
| nsg-app | 1000 | `Allow-LB` | AzureLoadBalancer | asg-app | 8080 | Allow |
| nsg-app | 4000 | `Deny-Vnet` | VirtualNetwork | any | any | **Deny** |
| nsg-db | 100 | `allow-app-to-db` | asg-app | asg-db | 5432 | Allow |
| nsg-db | 120 | `allow-bastion` | 10.30.4.0/26 | asg-db | 22 | Allow |
| nsg-db | 2000 | `Deny-Vnet` | VirtualNetwork | any | any | **Deny** |

Why the `Deny-Vnet` rules exist: Azure's default rule **AllowVnetInBound** (priority 65000) lets every VM in the network talk to every other. Without an explicit deny at a lower number, the tiers would not be isolated.

Why `Allow-LB` sits *above* `Deny-Vnet` on nsg-app: the load balancer's health probes come from `168.63.129.16`, which counts as part of `VirtualNetwork`. Without the allow rule first, the deny blocks the probes and the internal load balancer marks the VM unhealthy.

## Deploy

Pick one format from [`template/`](template/):

| File | Tool | Status |
|---|---|---|
| `project-3.arm.json` | Azure CLI / portal | Primary. Cleaned from the portal export |
| `project-3.bicep` | Azure CLI (Bicep) | Same content as the ARM file, in Bicep |
| `project-3.tf` | Terraform | **Experimental.** Portal-generated, edited by hand, untested |

```bash
az group create -n Project_3 -l eastus

# ARM template
az deployment group create -g Project_3 \
  -f template/project-3.arm.json \
  -p adminPassword='<a-strong-throwaway-password>'

# or Bicep
az deployment group create -g Project_3 \
  -f template/project-3.bicep \
  -p adminPassword='<a-strong-throwaway-password>'
```

What the template does **not** do: it does not start the test servers, and it does not enable the VM backup. After deployment, run the scripts below and set up backup in the portal (steps below).

> [!NOTE]
> The templates came from the Azure portal's *Export template* and were edited to remove duplicates and a circular dependency, add tags and make the storage name unique. They have been checked for structure but were not test-deployed. If something fails, open an issue.

### 1. Start a test listener on each VM

Connect with Bastion (VM > Connect > Bastion), copy [`scripts/listeners.sh`](scripts/listeners.sh) onto the VM, then:

```bash
sudo bash listeners.sh web   # on web-vm1 and web-vm2   (port 80)
sudo bash listeners.sh app   # on vm-app                (port 8080)
sudo bash listeners.sh db    # on vm-db                 (port 5432)
```

Stuck on the VM-less route? The portal's **Run command > RunShellScript** can run the same commands.

### 2. Enable backup for vm-db

1. Create or open the vault `vm-db-backup`.
2. Before protecting anything, check **Settings > Properties > Backup Configuration**. The default storage redundancy is geo-redundant. Switch to locally-redundant first if you want the cheaper option, because it cannot change once an item is protected.
3. **+ Backup** > Azure > Virtual machine, choose a policy, add `vm-db`.

The lab used the enhanced policy `EnhancedPolicy-mwl9exne`: weekly on Sunday at 12:00 UTC, 7 days of instant restore, 12 weeks of retention.

### 3. Mount the file share

```bash
STORAGE_KEY='<paste from Access keys, never commit>' bash scripts/mount-files.sh <storage-account-name>
```

## Prove it

Full commands and expected output are in [`scripts/tests.md`](scripts/tests.md). The short version:

| Test | Expected |
|---|---|
| Hit the public IP six times | Alternates `web-vm1` and `web-vm2` |
| Web VM calls the internal LB on 8080 | `200` |
| App VM opens port 5432 on the DB | Open |
| Web VM opens port 5432 on the DB | Blocked |
| Deallocate `web-vm1` | Site keeps working from `web-vm2` |
| Mount the share from `vm-app` | Works |
| Mount the share from a web VM | `Permission denied` |

## Screenshots

Identifiers (subscription ID, emails, public IPs, usernames) are redacted. Images are numbered in build order, and the numbers in brackets match the requirements above.

**Finished build**

![Architecture exported from the resource visualizer](images/01-architecture-resource-visualizer.png)
![Resource list for the Project_3 resource group](images/02-all-resources.png)

**Network security groups (R1 to R4)**

![nsg-web rules](images/03-nsg-web-rules.png)
![nsg-app rules](images/04-nsg-app-rules.png)
![nsg-db rules](images/05-nsg-db-rules.png)
![Effective security rules on the database NIC](images/06-effective-rules-db-nic.png)

**Public load balancer (R1, R6, R7)**

![Public load balancer overview](images/07-public-lb-overview.png)
![Frontend IP configuration](images/08-public-lb-frontend-ip.png)
![Health probe](images/09-public-lb-health-probe.png)
![Backend pool](images/10-public-lb-backend-pool.png)
![Load balancing rule health: both VMs up](images/11-public-lb-rule-health.png)
![Six requests alternate between the two web VMs](images/12-public-lb-rotation-test.png)
![A second run of the rotation test](images/13-public-lb-rotation-test-2.png)

**Internal load balancer (app tier)**

![Adding the internal load balancing rule (frontend 10.30.2.10)](images/14-internal-lb-add-rule.png)
![Internal load balancer health probe](images/15-internal-lb-health-probe.png)

**Tier listeners**

![Creating the app listener as a systemd service on vm-app](images/16-app-listener-create.png)
![Checking the app listener from vm-app itself](images/17-app-listener-self-test.png)
![Service is active and answers locally](images/18-app-listener-active.png)
![Creating the database listener on port 5432](images/19-db-listener-create.png)

**Tier-to-tier tests (R2, R3)**

![web-vm2 reaches the app VM on 8080 (200)](images/20-test-web-to-app-ok.png)
![App VM reaches the database tier on 5432 (200)](images/21-test-app-to-db-ok.png)
![web-vm2 cannot reach the database tier (timeout)](images/22-test-web-to-db-blocked.png)
![web-vm2 to the internal load balancer address, timed out](images/23-test-web-to-internal-lb-timeout.png)
![web-vm1 to the internal load balancer address, no response (000)](images/24-test-web-vm1-internal-lb-000.png)

**Bastion access**

![Bastion session to vm-app](images/25-bastion-vm-app.png)
![Bastion session to vm-db](images/26-bastion-vm-db.png)
![Database listener on 5432, reached through Bastion](images/27-db-listener-5432.png)

**Azure Files and the storage firewall (R8)**

![Storage firewall: selected networks only](images/28-storage-firewall.png)
![Service endpoint enabled for snet_app](images/29-storage-service-endpoint.png)
![Resource instances and exceptions](images/30-storage-resource-instances.png)
![The casefiles share](images/31-files-share.png)
![Mount succeeds from the app VM](images/32-files-mount-ok-app-vm.png)
![Mount is refused from a web VM](images/33-files-mount-denied-web-vm.png)

**Backup (R9)**

![Recovery Services vault overview](images/34-backup-vault-overview.png)
![vm-db protected, initial backup pending](images/35-backup-protection-pending.png)
![Weekly backup policy](images/36-backup-policy-weekly.png)
![Vault properties: soft delete Enabled - Always On](images/37-vault-soft-delete.png)
![Vault properties overview](images/38-vault-properties.png)
![AzureBackupRG left behind by Azure Backup (delete it after the vault)](images/39-azurebackup-leftover-rg.png)

**Export template**

![Export template page for the resource group (ARM tab)](images/40-export-template.png)

**A mistake worth seeing**

![Placeholder left in a command (<DB IP>) gives "cannot open DB"](images/41-mistake-placeholder-left-in-command.png)

## Things that went wrong (and the fix)

| Symptom | Cause | Fix |
|---|---|---|
| Internal LB test times out | Health probe port (80) did not match the listener port (8080) | Set the probe to 8080 |
| Internal LB unhealthy even with the right port | `Deny-Vnet` blocked the probe | Add `Allow-LB` above the deny rule |
| Public IP serves only one VM | The load-balancing rule pointed at a pool with one VM | Point the rule at `bp-web` that holds both |
| ASG option missing in the VM wizard | ASGs are assigned on the NIC, after the VM exists | VM > Networking > NIC > Application security groups |
| Portal Run command hangs | `ping` with no `-c` never ends | Use `curl` or `ping -c 1` |
| Bastion SSH rule had the wrong port | Rule typed with 8080 instead of 22 | Correct to 22 |
| Storage key shows in a screenshot or paste | Easy to leak | Treat as exposed, rotate it, never commit it |

## Cost notes

| Resource | Bills while it exists |
|---|---|
| 4 VMs (Standard_D2s_v6) | Yes, until deallocated or deleted |
| Bastion (Basic) | Yes, hourly |
| NAT gateway + public IP | Yes, hourly |
| 2 load balancers (Standard) and 3 public IPs | Yes |
| Storage account + Azure Files | Small |
| Backup vault | Small until backups exist |

## Teardown

1. Delete Bastion and the NAT gateway first (the most expensive per hour).
2. In the vault: **Backup items > vm-db > Stop backup > Delete backup data**.
3. The vault has **soft delete Always On** (14 days), so it cannot be removed straight away. Delete everything else now by deleting the other resources or the resource group; if the group refuses because of the vault, remove the rest and delete the vault after the retention period.
4. Look for a leftover `AzureBackupRG_...` resource group and delete it.
5. Check Cost Management the next day.

## AZ-104 mapping

- **Networking:** subnets and CIDR, NSG priorities and default rules, ASGs, service endpoints, NAT gateway, Bastion, public vs internal load balancers, health probes
- **Compute:** availability zones, VM NICs, accelerated networking
- **Storage:** Azure Files, storage firewall, service endpoint vs private endpoint
- **Monitor and maintain:** Recovery Services vault, backup policy, soft delete

> Unofficial study material. Not affiliated with or endorsed by Microsoft.
