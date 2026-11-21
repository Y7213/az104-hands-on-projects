# AZ-104 Hands-On Projects

Scenario-based Azure labs for people studying for the **Microsoft AZ-104 (Azure Administrator)** exam. Each project is a small, realistic business problem. You build it by hand in the portal first, so you understand *why* each setting exists, then you can redeploy it from the included templates.

> Unofficial study material. Not affiliated with or endorsed by Microsoft. Contains no Microsoft Learn text or exam content.

## Projects

| Project | Scenario | You practise | Level |
|---|---|---|---|
| [5: Secure Client-Data Platform](project-5-secure-client-data/) | Accounting firm keeps client tax records private and auditable | Storage security, private endpoints, RBAC, Policy, logging | Intermediate |
| [2: Manufacturer Hub-and-Spoke Network](project-2-hub-and-spoke-network/) | Two plants and a head office connected through a hub, OT locked off from the internet | Peering, user-defined routes, NVA, VPN gateway, Private DNS, Azure Firewall, Network Watcher | Advanced |
| [3: Three-Tier Law-Firm ERP](project-3-three-tier-erp/) | Web, app and database tiers that can only talk to the next tier | NSGs and ASGs, load balancers, zones, Bastion, Azure Files, backup | Intermediate |

More projects will follow.

## How each project is laid out

| Folder | What it holds |
|---|---|
| `README.md` | Scenario, requirements, architecture diagram, steps, tests, screenshots, pitfalls |
| `template/` or `infra/` | Deployable templates (ARM, and Bicep or Terraform where available) |
| `scripts/` | Test commands and helper scripts |
| `images/` | Redacted screenshots of the finished lab |

## Before you start

> [!WARNING]
> Azure resources cost money. Use a free trial, set a budget alert, tag everything with an `expires` date and follow each project's teardown section. See [docs/teardown.md](docs/teardown.md).

- Templates are exports and rebuilds of real labs. They were checked for structure but **not all test-deployed**, so expect to fix small things.
- Never commit keys, SAS tokens, passwords or your subscription ID. See [docs/redaction-checklist.md](docs/redaction-checklist.md).

## Licence

MIT. See [LICENSE](LICENSE).
