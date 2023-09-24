# escape=`

# .NET Framework 4.7.1が入った Windows Server Coreイメージを使用する
ARG FROM_IMAGE=mcr.microsoft.com/dotnet/framework/runtime:4.7.2-windowsservercore-ltsc2019
FROM ${FROM_IMAGE} AS recommended

ARG TEMP_PATH="C:\TEMP"

# インストールスクリプトをコピーしておく
ENV INSTALL_CMD_PATH="${TEMP_PATH}\Install.cmd"
COPY Install.cmd ${INSTALL_CMD_PATH}

# Download collect.exe in case of an install failure.
ENV COLLECT_PATH="${TEMP_PATH}\collect.exe"
ADD https://aka.ms/vscollect.exe ${COLLECT_PATH}

# Use the latest release channel. For more control, specify the location of an internal layout.
ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ENV VISUALSTUDIO_CHANNEL_URL_PATH="${TEMP_PATH}\VisualStudio.chman"
ADD ${CHANNEL_URL} ${VISUALSTUDIO_CHANNEL_URL_PATH}

# デフォルトのシェルを復元する(powershellなどにされている場合に備えて)
SHELL ["cmd", "/S", "/C"]

# C++ ビルドツールをインストール
ENV VS_BUILDTOOLS_PATH="${TEMP_PATH}\vs_buildtools.exe"
# cf. https://learn.microsoft.com/ja-jp/visualstudio/install/build-tools-container
ARG VISUALSTUDIO_VERSION=15
ADD https://aka.ms/vs/${VISUALSTUDIO_VERSION}/release/vs_buildtools.exe ${VS_BUILDTOOLS_PATH}
# Visual Studio Build Tools のコンポーネント ディレクトリ（開発ツール、ランタイム、SDK、等々）
# cf. https://learn.microsoft.com/ja-jp/visualstudio/install/workload-component-id-vs-build-tools
# ここでは、C++開発環境のうち推奨コンポーネントまでをインストール
RUN %INSTALL_CMD_PATH% %VS_BUILDTOOLS_PATH% --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --channelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
    --installChannelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended

FROM recommended as additional-tools

# Windows 8.1 SDK # なぜか10じゃzlibのコンパイルが通らないの： The Windows SDK version 8.1 was not found. Install the required version of Windows SDK or change the SDK version in the project property pages or by right-clicking the solution and selecting 
RUN %INSTALL_CMD_PATH% %VS_BUILDTOOLS_PATH% --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --channelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
    --installChannelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
    --add Microsoft.VisualStudio.Component.Windows81SDK `
    --add Microsoft.Component.VC.Runtime.UCRTSDK

# git for Windows(latest)
ARG GIT_INSTALLER_NAME=install_git_for_windows.ps1
ENV GIT_INSTALL_PATH="C:\Git" `
    TEMP_GIT_INSTALLER_PATH="${TEMP_PATH}\${GIT_INSTALLER_NAME}"
COPY ${GIT_INSTALLER_NAME} ${TEMP_GIT_INSTALLER_PATH}
RUN powershell %TEMP_GIT_INSTALLER_PATH% %GIT_INSTALL_PATH%

# AWS CLI v2
# TODO：これ指定できないかなあ？オプションあると思うんだけど
ENV AWSCLIV2_INSTALL_PATH="c:\Program Files\Amazon\AWSCLIV2"
RUN msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /qn

# Install CMake
ARG CMAKE_INSTALLER_NAME=install_cmake.ps1
ENV CMAKE_INSTALL_PATH="C:\CMake" `
    TEMP_CMAKE_INSTALLER_PATH="${TEMP_PATH}\${CMAKE_INSTALLER_NAME}"
COPY ${CMAKE_INSTALLER_NAME} ${TEMP_CMAKE_INSTALLER_PATH}
RUN powershell %TEMP_CMAKE_INSTALLER_PATH% %CMAKE_INSTALL_PATH%

# Install Python
ARG PYTHON_INSTALLER_URL=https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe `
    PYTHON_INSTALLER_PATH=python-amd64.exe
ENV PYTHON_INSTALL_PATH="C:\Pyhton" `
    TEMP_PYTHON_INSTALLER_PATH="${TEMP_PATH}\${PYTHON_INSTALLER_PATH}"
# cf. https://docs.python.org/ja/3.11/using/windows.html#installing-without-ui
RUN powershell Invoke-WebRequest `
        -Uri https://www.python.org/ftp/python/3.11.5/python-3.11.5-amd64.exe `
        -OutFile %TEMP_PYTHON_INSTALLER_PATH%; `
    %TEMP_PYTHON_INSTALLER_PATH% /quiet `
        TargetDir=%PYTHON_INSTALL_PATH% `
        Include_pip=1 `
        InstallAllUsers=0 `
        Include_launcher=0 `
        Include_test=0 `
        SimpleInstall=1


# Add path
RUN setx /M PATH "%PATH%;%CMAKE_INSTALL_PATH%\bin;%AWSCLIV2_INSTALL_PATH%;%GIT_INSTALL_PATH%;%PYTHON_INSTALL_PATH%;%PYTHON_INSTALL_PATH%\Scripts"

# FROM recommended AS atl-mfc-cli

# # MFC, ATL, C++/CLI
# RUN %INSTALL_CMD_PATH% %VS_BUILDTOOLS_PATH% --quiet --wait --norestart --nocache `
#     --installPath C:\BuildTools `
#     --channelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
#     --installChannelUri %VISUALSTUDIO_CHANNEL_URL_PATH% `
#     --add Microsoft.VisualStudio.Component.VC.ATL `
#     --add Microsoft.VisualStudio.Component.VC.ATLMFC `
#     --add Microsoft.VisualStudio.Component.VC.CLI.Support

# デフォルトでPowerShellを使用する
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

# Visual Studio Build Toolsの環境変数を設定してからコマンドを実行するようにする
# これ悪さしてない？？
# ENTRYPOINT ["C:\BuildTools\Common7\Tools\VsDevCmd.bat", "-arch=amd64", "-host_arch=amd64"]
# "C:\BuildTools\Common7\Tools\VsDevCmd.bat -arch=amd64 -host_arch=amd64"

# References
# - https://qiita.com/tetsurom/items/d2aac2e56f024b3178fb
# - https://learn.microsoft.com/ja-jp/visualstudio/install/advanced-build-tools-container?view=vs-2022
