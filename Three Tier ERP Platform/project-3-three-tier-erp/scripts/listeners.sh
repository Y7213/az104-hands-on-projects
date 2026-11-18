#!/usr/bin/env bash
# Starts a tiny test web server that stands in for each tier, as a systemd service so it survives reboots.
# Run on the matching VM:   sudo bash listeners.sh web|app|db
# Why a fake server: the lab proves NETWORK rules (NSGs, load balancers), not application code.
set -euo pipefail
TIER="${1:?usage: sudo bash listeners.sh web|app|db}"
case "$TIER" in
  web) PORT=80   ;;
  app) PORT=8080 ;;
  db)  PORT=5432 ;;
  *) echo "tier must be web, app or db"; exit 1 ;;
esac
DIR="/srv/$TIER"
mkdir -p "$DIR"
echo "<h1>${TIER^} tier - $(hostname)</h1>" > "$DIR/index.html"
cat > "/etc/systemd/system/${TIER}.service" <<EOF
[Unit]
Description=${TIER} tier test listener
After=network.target
[Service]
WorkingDirectory=$DIR
ExecStart=/usr/bin/python3 -m http.server $PORT
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now "${TIER}.service"
ss -tlnp | grep ":$PORT" || true
