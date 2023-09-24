################################################################################
# 
# Install Git for Windows
# 
# Usage:
# powershell install_git_for_windows.ps1 <install_path>
#     - <install_path> : Git をインストールするフォルダ
# 
################################################################################

# インストール先
$install_path = $args[0]

# 配布元
$installer_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"

# Installer バージョンによらず固定名にする
$installer_name = "Git-latest-64-bit.exe"

# Download git for Windows(latest)
Invoke-WebRequest -Uri (Invoke-RestMethod -Method Get -Uri $installer_url | % assets | where name -like "*64-bit.exe").browser_download_url -OutFile ${installer_name}

# インストール時の設定
# core.autocrlf = false にする（CRLFOption=CRLFCommitAsIs）など
# cf. https://github.com/git-for-windows/build-extra/blob/HEAD/installer/install.iss
$git_install_inf = "$env:temp\setup.inf"
Set-Content -Path $git_install_inf  -Force -Value "
[Setup]
Lang=default
Dir=${install_path}
Group=Git
NoIcons=0
SetupType=default
Components=
Tasks=
PathOption=Cmd
SSHOption=OpenSSH
CRLFOption=CRLFCommitAsIs
"

# run installer
$install_args = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$git_install_inf"""
Start-Process -FilePath ${installer_name} -ArgumentList $install_args -Wait
