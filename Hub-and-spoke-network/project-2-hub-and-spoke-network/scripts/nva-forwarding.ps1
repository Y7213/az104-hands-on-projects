# Run on vm-NVA (portal: VM > Operations > Run command > RunPowerShellScript).
# The Azure NIC setting "Enable IP forwarding" only lets Azure deliver foreign packets to the NIC.
# Windows itself must also be willing to route them, otherwise it drops them.

# Turn on forwarding on every IPv4 interface
Get-NetIPInterface -AddressFamily IPv4 | Set-NetIPInterface -Forwarding Enabled

# Make it survive a reboot (IPEnableRouter = 1 is the classic "act as a router" switch)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name IPEnableRouter -Value 1

# Check
Get-NetIPInterface -AddressFamily IPv4 | Select-Object InterfaceAlias, Forwarding
