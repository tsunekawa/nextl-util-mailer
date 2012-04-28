#-*- coding:utf-8 -*-

require 'mail'
require 'erubis'

module NextL::Mailer

  def self.new
    ::NextL::Mailer::Mailer.new
  end

  autoload "Mailer", File.expand_path(File.join(File.dirname(__FILE__), %w{ mailer mailer }))
  autoload "Logger", File.expand_path(File.join(File.dirname(__FILE__), %w{ mailer logger }))
end
