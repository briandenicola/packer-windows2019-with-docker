:: Set Execution Policy 64 Bit
cmd.exe /c powershell -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force"

:: Zero Hibernation File
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f

:: Disable Hibernation Mode
%SystemRoot%\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f

:: Disable Network Prompt 
%SystemRoot%\System32\reg.exe ADD HKLM\System\CurrentControlSet\Control\Network\NewNetworkWindowOff

:: Disable password expiration for manager user
cmd.exe /c wmic useraccount where "name='manager'" set PasswordExpires=FALSE