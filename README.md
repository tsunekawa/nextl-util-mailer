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
