NextL-Util-Mailer
=================

NextL-Util-Mailer はNextLのメーリングリストに関するスクリプト集です。

セットアップ(Setup)
-------------------

    $ git clone http://github.com/tsunekawa/nextl-util-mailer.git
    $ bundle install
    $ cp config/mailconf.yml.sample config/mailconf.yml
    $ (edit config/mailconf.yml ...)

使い方(Usage)
-------------

最新1件の Issue をメールとして転送する。

    $ script/sendissue 1

ウェブアプリケーションとしてスクリプトを起動する。

    $ rackup

カスタマイズ(Customize)
-----------------------

メールの文面を変更するには、テンプレートを編集してください。

    $ cd lib/next_l/mailer/templates
    $ ( issues.erb または issues_comment.erb を編集 ...)

