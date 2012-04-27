#-*- coding:utf-8 -*-

require 'mail'
require 'erubis'

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
    result = case event["type"]
      when "IssuesEvent"
        render_issue(event)
      when "IssueCommentEvent"
        render_issues_comment(event)
      else
        raise
    end

    @mail.content_type 'text/plain'
    @mail.charset = 'ISO-2022-JP'
    @mail.subject      result[:subject]
    @mail.body         result[:body]

    self
  end

  # ja: IssuesEventの場合の件名と本文をレンダリング
  def render_issue(event)
    set_renderer("issues")
    @issue    = event["payload"]["issue"]

    {
      :subject => "issue #{@issue["number"]} - #{@issue["title"]}",
      :body    => @renderer.evaluate(self)
    }
  end

  # ja: IssueCommentの場合の件名と本文をレンダリング
  def render_issues_comment(event)
    set_renderer("issues_comment")
    @issue = event["payload"]["issue"]
    @comment = event["payload"]["comment"]

    {
      :subject => "issue #{@issue["number"]} - #{@issue["title"]}",
      :body    => @renderer.evaluate(self)
    }
  end

  def set_renderer(type)
    template = File.read(File.join(::NextL::Config[:template_dir], "#{type}.erb"))
    @renderer = Erubis::Eruby.new(template)
  end

  def url_for(type,context={})
    case type.to_sym
      when :issues_comment
        "http://github.com/nabeta/enju_leaf/issues/#{context[:issue_number]}#issuecomment-#{context[:comment_id]}"
      when :issue
        "http://github.com/issues/#{context[:issue_number]}"
      when :user
        "http://github.com/#{context[:login]}"
      else
        raise
    end
  end

  # ja: メールの送受信に関する処理は@mailに委譲する
  def method_missing(methodname, *args)
    if @mail.respond_to? methodname
      @mail.send(methodname, *args)
      self
    end
  end
end
