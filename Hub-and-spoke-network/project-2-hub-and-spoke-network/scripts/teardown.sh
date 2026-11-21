#!/usr/bin/env bash
# Delete the expensive pieces first so billing stops, then the whole group.
set -euo pipefail
RG=Project_2
az network vpn-connection delete -g "$RG" -n hub-to-office   || true
az network vpn-connection delete -g "$RG" -n office-to-hub   || true
az network firewall delete       -g "$RG" -n fw-hub          || true
az network vnet-gateway delete   -g "$RG" -n VPN-Hub         || true
az network vnet-gateway delete   -g "$RG" -n VPN-Office      || true
az network public-ip delete      -g "$RG" -n pip-fw-hub      || true
az group delete -n "$RG" --yes --no-wait
