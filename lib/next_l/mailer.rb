#-*- coding:utf-8 -*-

# ja: NextLのメーリングリストにメールを送るモジュール
module NextL::Mailer
  # ja: enju_leaf に投稿された Issue のメールを作成する
  def self.issues(opts={})
    limit = (opts[:limit] || -1).to_i
    mailconf = ::NextL::Config[:mail]
    issues   = ::NextL::EnjuRepo.issues[0..limit].reverse

    issues.map do |event|
      issue    = event["payload"]["issue"]
      body_str = case event["type"]
        when "IssuesEvent"
          issue["body"]
        when "IssueCommentEvent"
          event["payload"]["comment"]["body"]
        else
          raise
      end

      Mail.new do
        from    mailconf[:recipient]
        to      mailconf[:to]
        subject "issue #{issue["number"]} - #{issue["title"]}"
        body    body_str
      end
    end
  end

  # ja: 取得した Issue をすべて転送する
  def self.deliver_issues(opts={})
    self.issues(opts).each{|mail|
      mail.deliver!
      puts mail.subject
    }
  end
end
