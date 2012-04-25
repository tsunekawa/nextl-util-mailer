#-*- coding:utf-8 -*-

require 'cgi'
require 'mail'
require 'yaml'
require 'json'
require 'open-uri'

#Next-Lの活動を支援するユーティリティ
module NextL
  autoload "EnjuRepo", File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l enju_repo }))
  autoload "Mailer", File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l mailer }))
  Config = Hash.new
end
