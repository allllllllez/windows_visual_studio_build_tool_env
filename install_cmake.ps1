################################################################################
# 
# Install CMake
# 
# Usage:
# powershell install_cmake.ps1 <install_path>
#     - <install_path> : CMake をインストールするフォルダ
# 
################################################################################

# インストール先
$install_path = $args[0]

# 配布元
$installer_url = "https://api.github.com/repos/Kitware/CMake/releases/latest"

# Install
msiexec.exe /i (Invoke-RestMethod -Method Get -Uri $installer_url | % assets | where name -like "*windows-i386.msi").browser_download_url /qn INSTALL_ROOT=${install_path}
