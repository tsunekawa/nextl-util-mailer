# ja: NextLのメーリングリストにメールを送るモジュール
class NextL::Mailer::Mailer
  include NextL::Mailer::Logger

  def initialize
    @mailconf = ::NextL::Config[:mail]
  end


  def create_mail(&block)
    ::NextL::Mail.new(self, &block)
  end

  # ja: enju_leaf に投稿された Issue のメールを作成する
  def issues(opts={})
    limit = (opts[:limit] || -1).to_i
    issues   = ::NextL::EnjuRepo.issues[0..limit].reverse

    issues.map do |event|
      mail = create_mail do |mail|
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
      add_log(mail)
    }
  end
end
