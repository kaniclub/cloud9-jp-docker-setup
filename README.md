# AWS Cloud9独自開発環境

このリポジトリは、Amazon EC2 の代わりに独自サーバー上で日本語の開発環境を構築するためのDocker構成です。Ubuntu 20.04をベースに、Ruby、Rails、PostgreSQLの指定バージョンをインストールできます。

## 必要条件

- Docker
- docker-compose

## インストール

1. リポジトリをクローンします。
   \`\`\`bash
   git clone https://github.com/kaniclub/cloud9-jp-docker-setup.git
   \`\`\`

2. \`.env.orig\`ファイルを編集し、必要な環境変数を設定します。

3. \`make_env.sh\`を起動して\`.env\`ファイルを作成し、内容を変更します。
   \`\`\`bash
   ./docker/aws_cloud9/make_env.sh
   \`\`\`

4. コンテナをビルドと起動します。
   \`\`\`bash
   docker-compose up --build -d
   \`\`\`

## 環境変数

以下の環境変数を\`.env.orig\`ファイルで設定できます。

- \`NAME\`: コンテナ名
- \`TZ\`: タイムゾーン（例: \`Asia/Tokyo\`）
- \`LANG\`: ロケール設定（例: \`ja_JP.UTF8\`）
- \`PASSWORD\`: ユーザーパスワード
- \`PORT\`: 開放するポート
- \`POSTGRES_VER\`: PostgreSQLのバージョン
- \`POSTGRES_USER\`: PostgreSQLのユーザー名
- \`POSTGRES_PASSWORD\`: PostgreSQLのパスワード
- \`POSTGRES_DB\`: PostgreSQLのデータベース名
- \`USER\`: システムユーザー名
- \`UID\`: システムユーザーID
- \`GID\`: システムグループID
- \`RUBYVER\`: インストールするRubyのバージョン
- \`RAILSVER\`: インストールするRailsのバージョン

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。