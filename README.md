# 時間管理Webアプリ
このアプリケーションはいつどんな行動をしたかを記録するアプリです。記録した内容は公開されます。

使って欲しい人
- 日々ダラダラと過ごしている
- 一年があっという間に立っている
- 日々をもっと大切に生きていきたい
- 他の人がどの様に行動しているかが気になる

主な使い方
1. 自分の行動を記録して振り返る。
2. 他の人の行動を参考にする。

行動を振り返り、より良く改善していきましょう！


## git cloneからの導入方法（作成中）
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