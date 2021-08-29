[![Build on schedule/push](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/build_weekly.yml/badge.svg)](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/build_weekly.yml)
[![Snyk Container](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/snyk-container-analysis.yml/badge.svg)](https://github.com/KEINOS/VSCode-Dev-Container-Go/actions/workflows/snyk-container-analysis.yml)

# VSCode-Dev-Container-Go

```bash
docker pull ghcr.io/keinos/vscode-dev-container-go:latest
```

**`latest` タグのイメージは毎週月曜日に自動ビルドされたものか、`main` にマージされた直近のイメージ**です。

そのため、常に最新の Go version およびパッチの当たったイメージです。各種開発ツールがバージョン依存する場合は、下記のバージョン・タグ付きイメージを利用してください。

- [バージョン・タグ付きのイメージ一覧](https://github.com/KEINOS/VSCode-Dev-Container-Go/pkgs/container/vscode-dev-container-go)

---

VSCode の Remote-Containers で Golang 開発をするための Docker コンテナに使うベース・イメージです。

@KEINOS が個人的に開発時に良く使う OS のパッケージ（`apk`）、Go のパッケージ、開発支援ツール（ユニットテストや静的解析ツール）などを[予めインストール](image_info.txt)しています。

- イメージの概要
  - Alpine ベース（ARM64/intel 互換向け）
  - Go 1.17
  - Time Zone: Japan (UTC +9:00 = JST)
  - Locale: `ja_JP.utf8`
  - デフォルトユーザ: `vscode`:`vscode` (UID:GID=1000:1000)
  - インストール済みのパッケージ情報: [image_info.txt](image_info.txt)
  - [Dockerfile](https://github.com/KEINOS/VSCode-Dev-Container-Go/blob/main/Dockerfile)
  - Container Analysis ([セキュリティ](SECURITY.md))
    - [Snyk Container Analysis](https://github.com/snyk/actions/tree/master/docker)
      - `docker scan --severity=high` チェック済み
    - [Dockle](https://github.com/goodwithtech/dockle) ([.dockleignore](.dockleignore))
