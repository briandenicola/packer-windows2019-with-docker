Stop-Service -Name wuauserv
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"  -Name "AUOptions" -Value 4
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update"  -Name "CachedAUOptions" -Value 4
Start-Service -Name wuauserv

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module PSWindowsUpdate -Repository PSGallery -Confirm:$false -Force