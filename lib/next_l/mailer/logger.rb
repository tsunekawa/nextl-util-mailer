# -*- coding:utf-8 -*-

# ja: 転送したメールのログを記録・出力するモジュール
module NextL::Mailer::Logger

  def setup_logger
    @logger ||= ::NextL::Mailer::Logger::Logger.new
  end

  def log
    setup_logger
    @logger.log
  end

  def latest_log
    setup_logger
    @logger.latest_log
  end

  def add_log(mail)
    setup_logger
    @logger << mail
  end

  class Logger
    def initialize
      @log = Redis::List.new("next_l:mailer:log", :marshal=>true)
    end

    # ja: ログの記録
    def << (mail)
      record = Array.new
      record[0] = Time.now
      record[1] = mail.to_hash

      @log << record
      self
    end

    # ja: ログの表示
    def log
      @log.to_a
    end

    # ja: 最新のログを表示する
    def latest_log
      log.last
    end
  end
end
