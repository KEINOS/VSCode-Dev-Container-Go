# セキュリティ・ポリシー

## 常に最新バージョン

毎週月曜日の朝 3 時に定期的にビルドが行われ `latest` イメージが更新されます。（`main` ブランチへの `push` 時にもビルドされます）

- メリット
  - パッチの当たったものが提供される。
  - バージョン依存の早期発見につながる。
  - [セキュリティ・アラート](https://github.com/KEINOS/VSCode-Dev-Container-Go/security)に気づきやすくなる。
- デメリット
  - ツールや Alpine のバージョンアップに伴う不具合を含めてしまう。
  - ツールや OS のバージョン依存がある場合に動かなくなってしまう。

上記を踏まえ、開発用のコンテナとは言え、安定した環境よりは**最新バージョンの環境を提供することを目的としています**。

安定したバージョンの開発環境が必要な場合は `latest` 以外の[固定バージョン](https://github.com/KEINOS/VSCode-Dev-Container-Go/pkgs/container/vscode-dev-container-go/versions)を利用ください。

## 不具合報告

- [Issues](https://github.com/KEINOS/VSCode-Dev-Container-Go/issues) にお願いします。
  - 対応案やサンプル・コードなど、対応に必要な情報などをいただけると助かります。
