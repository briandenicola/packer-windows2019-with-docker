$publickey = ""
$sshRoot = Join-Path -Path $ENV:USERPROFILE -ChildPath ".ssh"
$authorizedFile = Join-Path -Path $sshRoot -ChildPath "authorized_keys"

New-Item -Path $sshRoot -ItemType Directory
Out-File -FilePath $authorizedFile -Encoding ascii -InputObject $publickey

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

$kb = Get-WUHistory | Where-Object {$_.KB -imatch 'KB4480116' -and $_.Result -eq 'Succeeded' }
if($kb) {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Install-Module -Force OpenSSHUtils -Scope AllUsers

    Set-Service -Name ssh-agent -StartupType Automatic
    Set-Service -Name sshd -StartupType Automatic

    Start-Service ssh-agent
    Start-Service sshd

    New-NetFirewallRule -DisplayName "SSH (Server)" -Protocol TCP -LocalPort 22 -Action Allow 
}
else {
    #Get-WUInstall -KBid KB4480116
    Write-Output "KB4480116 is required to be installed first."
}