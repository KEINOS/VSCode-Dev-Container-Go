# VSCode-Dev-Container-Go

VSCode の Remote-Containers で Golang 開発をするための Docker コンテナに使うベース・イメージです。（Go 1.16, Debian ベース）

```bash
docker pull ghcr.io/keinos/vscode-dev-container-go:latest
```

- @KEINOS が個人的に開発時に良く使う Go や apt などのパッケージを予めインストールしています。（ARM64, intel x86_64互換向け）
  - インストール済みのパッケージ情報: [image_info.txt](image_info.txt)
  - [バージョン・タグ付きのイメージ一覧](https://github.com/KEINOS/VSCode-Dev-Container-Go/pkgs/container/vscode-dev-container-go)

- **`latest` タグのイメージは毎週月曜日に自動ビルドされたものか、`main` にマージされた直近のイメージ**です。そのため、各種開発ツールを利用する際にバージョン依存する場合は、タグ付きのイメージを利用してください。
