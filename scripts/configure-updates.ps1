Stop-Service -Name wuauserv
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"  -Name "AUOptions" -Value 4
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"  -Name "CachedAUOptions" -Value 4
Start-Service -Name wuauserv