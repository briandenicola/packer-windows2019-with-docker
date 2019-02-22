$publickey = ""
$sshRoot = Join-Path -Path $ENV:USERPROFILE -ChildPath ".ssh"
$authorizedFile = Join-Path -Path $sshRoot -ChildPath "authorized_keys"
$ssh_config = "C:\ProgramData\ssh\sshd_config"

New-Item -Path $sshRoot -ItemType Directory
Out-File -FilePath $authorizedFile -Encoding ascii -InputObject $publickey

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

$kb = Get-WUHistory | Where-Object {$_.KB -imatch 'KB4480116' -and $_.Result -eq 'Succeeded' }
if($kb) {
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    Install-Module -Force OpenSSHUtils -Scope AllUsers

    Set-Service -Name ssh-agent -StartupType Automatic
    Set-Service -Name sshd -StartupType Automatic
    New-NetFirewallRule -DisplayName "SSH (Server)" -Protocol TCP -LocalPort 22 -Action Allow 

    Start-Service ssh-agent
    Repair-AuthorizedKeyPermission $authorizedFile -Confirm:$false
    icacls $authorizedFile /remove "NT SERVICE\sshd"
    
    $sshd = Get-Content -Path $ssh_config -Raw
    $sshd = $sshd.Replace("Match Group administrators", "#Match Group administrators")
    $sshd = $sshd.Replace("       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys","#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys")^C
    $sshd | Out-File -Encoding ascii -FilePath $ssh_config
    Start-Service sshd
}
else {
    #Get-WUInstall -KBArticleID KB4480116
    Write-Output "KB4480116 is required to be installed first."
}