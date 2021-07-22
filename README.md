[![Build on schedule/push](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/build_weekly.yml/badge.svg)](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/build_weekly.yml)
[![Snyk Container](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/snyk-container-analysis.yml/badge.svg)](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/snyk-container-analysis.yml)

# VSCode-Dev-Container-Go

```bash
docker pull ghcr.io/keinos/vscode-dev-container-go:latest
```

VSCode の Remote-Containers で Golang 開発をするための Docker コンテナに使うベース・イメージです。

@KEINOS が個人的に開発時に良く使う Go や apt などのパッケージや開発支援ツール（ユニットテストや静的解析ツールなど）を予めインストールしています。

- イメージの概要 [[詳細情報](image_info.txt)]
  - Alpine ベース（ARM64/intel 互換向け）
  - Go 1.16
  - `docker scan` チェック済み
  - Time Zone: Japan (UTC +9:00 = JST)
  - Locale: `ja_JP.utf8`
  - デフォルトユーザ: `vscode`:`vscode` (UID:GID=1000:1000)
  - インストール済みのパッケージ情報: [image_info.txt](image_info.txt)
- **`latest` タグのイメージは毎週月曜日に自動ビルドされたものか、`main` にマージされた直近のイメージ**です。そのため、常に最新のパッチの当たったイメージである反面、各種開発ツールのバージョン依存する場合は、タグ付きのイメージを利用してください。
  - [バージョン・タグ付きのイメージ一覧](https://github.com/KEINOS/VSCode-Dev-Container-Go/pkgs/container/vscode-dev-container-go)
