# VSCode-Dev-Container-Go

VSCode の Remote-Containers で Golang 開発をするための Docker コンテナに使うベース・イメージです。（Go 1.16, Debian ベース）

- @KEINOS が個人的に開発時に良く使う Go や apt などのパッケージを予めインストールしています。（ARM64, intel x86_64互換向け）
  - インストール済みのパッケージ情報: [image_info.txt](image_info.txt)
- 常に最新の状態で開発するため、毎週月曜日にイメージを自動ビルドしています。そのため、開発ツールを利用するしたバージョン依存する
