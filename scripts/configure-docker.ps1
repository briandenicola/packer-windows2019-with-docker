Install-WindowsFeature -Name Containers
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DockerMsftProvider -Repository PSGallery -Confirm:$false -Force
Install-Package -Name Docker -ProviderName DockerMsftProvider -Confirm:$false -Force
Set-Service -Name Docker -StartupType Automatic