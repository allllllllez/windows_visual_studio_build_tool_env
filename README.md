# Windows Visual Studio Build tool environment

Windows で、使い捨ての Visual Studio ビルドツール環境を作るセット

# Requirements
- Windows
    - `Windows 10 Pro 22H2 ビルド 19045.3448` で動作確認
- Docker Desktop(Windows)
    - `Docker version 24.0.5, build ced0996` で動作確認
    - **Windwos コンテナモード** になっていること
        - ☆変更方法☆
          Windows の通知領域にある Docker Desktop icon の context menu から、
          "Switch to Windows containers..." を選択

# Setup

docker compose コマンドで dev_env サービスを開始してください。そこに Visual Studio ビルドツールとその他諸々がインストール済みの環境があります。

```
> docker compose run dev_env

**********************************************************************
** Visual Studio 2017 Developer Command Prompt v15.0
** Copyright (c) 2017 Microsoft Corporation
**********************************************************************
Microsoft Windows [Version 10.0.17763.4737]
(c) 2018 Microsoft Corporation. All rights reserved.
```

```
C:\src>check_tools.bat

C:\src>git --version
git version 2.42.0.windows.2

C:\src>cmake --version
cmake version 3.27.7

CMake suite maintained and supported by Kitware (kitware.com/cmake).

C:\src>aws --version
aws-cli/2.13.25 Python/3.11.5 Windows/10 exe/AMD64 prompt/off

C:\src>python --version
Python 3.11.5

C:\src>pip --version
pip 23.2.1 from C:\Pyhton\Lib\site-packages\pip (python 3.11)

C:\src>perl --version

This is perl 5, version 32, subversion 1 (v5.32.1) built for MSWin32-x64-multi-thread

Copyright 1987-2021, Larry Wall

Perl may be copied only under the terms of either the Artistic License or the
GNU General Public License, which may be found in the Perl 5 source kit.

Complete documentation for Perl, including FAQ lists, should be found on
this system using "man perl" or "perldoc perl".  If you have access to the
Internet, point your browser at http://www.perl.org/, the Perl Home Page.
```

# 実行例

TBD

