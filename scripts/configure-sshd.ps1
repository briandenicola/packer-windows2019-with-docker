param(
    [string] $publickey
)

if( [string]::IsNullorEmpty($publicKey) ) {
    $publicKey = $ENV:PUBKEY
}

if( $PSVersionTable.BuildVersion -le [Version]::New(10,0,17763,194) ) {
    throw "OpenSSH can not be installed on Windows version less than 10.0 (1809) Build 17763.194"
    exit
}

$sshRoot = Join-Path -Path $ENV:USERPROFILE -ChildPath ".ssh"
$authorizedFile = Join-Path -Path $sshRoot -ChildPath "authorized_keys"

New-Item -Path $sshRoot -ItemType Directory
Out-File -FilePath $authorizedFile -Encoding ascii -InputObject $publickey

$ssh_regKey = "HKLM:\SOFTWARE\OpenSSH"
$ssh_config = "C:\ProgramData\ssh\sshd_config"

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

if( Test-Path $ssh_config ) {
    Remove-Item -Path $ssh_config -Force 
}

Set-Service -Name ssh-agent -StartupType Automatic
Set-Service -Name sshd -StartupType Automatic
New-NetFirewallRule -DisplayName "SSH (Server)" -Protocol TCP -LocalPort 22 -Action Allow 

Start-Service ssh-agent
$sshd = Get-Content -Path $ssh_config -Raw

$sshd = $sshd.Replace("Match Group administrators", "#Match Group administrators")
$sshd = $sshd.Replace("       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys","#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys")
$sshd = $sshd.Insert($sshd.Length,"Subsystem    powershell c:/progra~1/powershell/7/pwsh.exe -sshs -NoLogo -NoProfile")
$sshd | Out-File -Encoding ascii -FilePath $ssh_config

Out-File -Encoding ascii -FilePath $ssh_config
Restart-Service sshd

$pwsh_path  = Get-Command -Name Powershell | Select-Object -ExpandProperty Source
New-ItemProperty -Path $ssh_regKey -Name DefaultShell -Value $pwsh_path -PropertyType String -Force 