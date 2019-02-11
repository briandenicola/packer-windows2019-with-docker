Enable-PSRemoting -SkipNetworkProfileCheck  -Force -Confirm:$false
Enable-WSManCredSSP -Role Server -Force
Set-NetFirewallRule -Name "WINRM-HTTP-In-TCP" -RemoteAddress Any
Start-Service -Name winrm
Set-Service -Name winrm -StartupType Automatic

$PubNets = Get-NetConnectionProfile -NetworkCategory Public -ErrorAction SilentlyContinue 
foreach ($PubNet in $PubNets) {
    Set-NetConnectionProfile -InterfaceIndex $PubNet.InterfaceIndex -NetworkCategory Private
}

winrm set winrm/config/service '@{AllowUnencrypted="true"}'