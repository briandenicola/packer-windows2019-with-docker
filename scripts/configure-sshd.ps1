param(
    [string] $publickey
)

if( [string]::IsNullorEmpty($publicKey) ) {
    $publicKey = $ENV:PUBKEY
}

$sshRoot = Join-Path -Path $ENV:USERPROFILE -ChildPath ".ssh"
$authorizedFile = Join-Path -Path $sshRoot -ChildPath "authorized_keys"

New-Item -Path $sshRoot -ItemType Directory
Out-File -FilePath $authorizedFile -Encoding ascii -InputObject $publickey

$ssh_regKey = "HKLM:\SOFTWARE\OpenSSH"
$ssh_config = "C:\ProgramData\ssh\sshd_config"
$pwsh_path  = Get-Command -Name Powershell | Select-Object -ExpandProperty Source

New-ItemProperty -Path $ssh_regKey -Name DefaultShell -Value $pwsh_path -PropertyType String -Force 

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
#Install-Module -Force OpenSSHUtils -Scope AllUsers

Set-Service -Name ssh-agent -StartupType Automatic
Set-Service -Name sshd -StartupType Automatic
New-NetFirewallRule -DisplayName "SSH (Server)" -Protocol TCP -LocalPort 22 -Action Allow 

Start-Service ssh-agent
#Repair-AuthorizedKeyPermission $authorizedFile -Confirm:$false
#icacls $authorizedFile /remove "NT SERVICE\sshd"

$sshd = Get-Content -Path $ssh_config -Raw
$sshd = $sshd.Replace("Match Group administrators", "#Match Group administrators")
$sshd = $sshd.Replace("       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys","#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys")
$sshd | Out-File -Encoding ascii -FilePath $ssh_config
Restart-Service sshd