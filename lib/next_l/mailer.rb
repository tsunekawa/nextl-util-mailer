#-*- coding:utf-8 -*-

# ja: NextLのメーリングリストにメールを送るモジュール
class NextL::Mailer

  def initialize
    @mailconf = ::NextL::Config[:mail]
  end

  # ja: enju_leaf に投稿された Issue のメールを作成する
  def issues(opts={})
    limit = (opts[:limit] || -1).to_i
    issues   = ::NextL::EnjuRepo.issues[0..limit].reverse

    issues.map do |event|
      mail = ::NextL::Mail.new do |mail|
        mail.from @mailconf[:recipient]
        mail.to @mailconf[:to]
      end
      mail.render_by_event(event)
    end
  end

  # ja: 取得した Issue をすべて転送する
  def deliver_issues(opts={})
    issues(opts).each{|mail|
      mail.deliver!
      puts mail.subject
    }
  end
end

# ja: NextLのMLに送るメールのオブジェクト
class NextL::Mail
  def initialize(&block)
    @mail = ::Mail.new
    yield @mail
  end

  # ja: GitHubのイベントに応じてタイトルと本文を変更する
  def render_by_event(event)
    type = case event["type"]
      when "IssuesEvent"
        render_issue(event)
      when "IssueCommentEvent"
        render_issues_comment(event)
      else
        raise
    end
    self
  end

  # ja: IssuesEventの場合の件名と本文をレンダリング
  def render_issues(event)
    issue    = event["payload"]["issue"]
    @mail.subject "issue #{issue["number"]} - #{issue["title"]}"
    @mail.body    event["payload"]["issue"]["body"]
  end

  # ja: IssueCommentの場合の件名と本文をレンダリング
  def render_issues_comment(event)
    issue    = event["payload"]["issue"]
    @mail.subject "issue #{issue["number"]} - #{issue["title"]}"
    @mail.body    event["payload"]["comment"]["body"]
  end

  # ja: メールの送受信に関する処理は@mailに委譲する
  def method_missing(methodname, *args)
    if @mail.respond_to? methodname
      @mail.send(methodname, *args)
      self
    end
  end
end
