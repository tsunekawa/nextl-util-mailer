#-*- coding:utf-8 -*-

# ja: NextLのMLに送るメールのオブジェクト
class NextL::Mail
  attr_reader :mailer

  def initialize(mailer,&block)
    @mailer = mailer
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

  def to_hash
    {
      :from => @mail.from,
      :to => @mail.to,
      :subject => @mail.subject,
      :body => @mail.body
    }
  end

  # ja: メールの送受信に関する処理は@mailに委譲する
  def method_missing(methodname, *args)
    if @mail.respond_to? methodname
      @mail.send(methodname, *args)
      self
    end
  end
end
