# Overview
A sample configuration to build a Windows 2019 VM with Docker for Hyper-V VM using Packer.

# Prep 
* Update AnswerFiles\Autounattend.xml <key></key> with your Windows 2019 ISO file
* Copy your Windows 2019 ISO file to iso folder
* Ensure you have Vagrant and Packer installed 

# Build
```
.\build_windows_2019_docker.ps1
```

# Run
```
.\run_vagrant_image.ps1
```

# Note
* A thanks to https://github.com/jonashackt/ansible-windows-docker-springboot and https://github.com/joefitzgerald/packer-windows