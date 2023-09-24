################################################################################
# 
# Install AWS CLI v2
# 
# Usage:
# powershell install_awscliv2.ps1
# 
################################################################################

# 配布元
$awscliv2_url = "https://awscli.amazonaws.com/AWSCLIV2.msi"

# Installer バージョンによらず固定名にする
$installer_name = "AWSCLIV2.msi"
$dl_path = "C:\TEMP\"+$installer_name

# Download installer
Invoke-WebRequest -Uri $awscliv2_url -OutFile $dl_path

# run installer
msiexec \i $dl_path \q
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn
