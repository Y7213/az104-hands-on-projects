# Run on every VM so ping works. Windows Firewall blocks inbound ICMP echo by default,
# which looks like a network fault but is not one.
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow
