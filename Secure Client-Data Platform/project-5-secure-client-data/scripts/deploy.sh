#!/usr/bin/env bash
# Usage: P5_VM_PASSWORD='...' ./deploy.sh [resource-group] [location]
set -euo pipefail
RG="${1:-Project_5}"; LOC="${2:-eastus}"
az group create -n "$RG" -l "$LOC" --tags project=project_5 expires=YYYY-MM-DD owner=your-handle >/dev/null
az deployment group what-if -g "$RG" -f ../infra/main.bicep -p ../infra/main.bicepparam
read -r -p "Deploy? [y/N] " ok; [ "$ok" = "y" ] || exit 0
az deployment group create -g "$RG" -f ../infra/main.bicep -p ../infra/main.bicepparam \
  --query properties.outputs -o json
