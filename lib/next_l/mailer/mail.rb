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
      when "PullRequestEvent"
        render_pull_request(event)
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

  # ja: PullRequestの場合の件名と本文をレンダリング
  def render_pull_request(event)
    set_renderer("pull_request")

    @pull_request    = event["payload"]["pull_request"]

    {
      :subject => "pull request #{@pull_request["number"]} - #{@pull_request["title"]}",
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
        "https://github.com/nabeta/enju_leaf/issues/#{context[:issue_number]}#issuecomment-#{context[:comment_id]}"
      when :issue
        "https://github.com/issues/#{context[:issue_number]}"
      when :user
        "https://github.com/#{context[:login]}"
      when :pull_request
        "https://github.com/nabeta/enju_leaf/pull/#{context[:pull_request_number]}"
      else
        raise
    end
  end

  def to_hash
    {
      :from => @mail.from.to_s,
      :to => @mail.to.to_s,
      :subject => @mail.subject.to_s,
      :body => @mail.body.to_s
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
