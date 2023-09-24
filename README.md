# Windows Visual Studio Build tool environment

Windows で、使い捨ての Visual Studio ビルドツール環境を作るセット

# requirements
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
```

# 実行例

Snowflake c/c++ Connector をビルドしてみます。

（いきなり開発用っぽい S3 にファイルを置きに行ってるのが怖い。。。コメントアウトしている）
