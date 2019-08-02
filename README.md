# バックエンドをRails、フロントエンドをReact.jsでのアプリ

## 使い方（作成中）
このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。

rails new time-manage_app -d postgresql -BT
  bundleをインストールせずに実行します。

config/database.ymlを環境ごとに変更します。

bundle install
  gemをインストールします。

rails webpacker:install
rails webpacker:install:react
rails generate react:install
  React.jsを使用するために上記コマンドを実行します。

rails db:create
  データベースへのマイグレーションを実行します。

rails s -b 0.0.0.0
  ブラウザからHello Railsが表示されることを確認します。
gasa
