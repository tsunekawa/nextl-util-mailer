#-*- coding:utf-8 -*-

require 'cgi'
require 'yaml'
require 'json'
require 'open-uri'
require 'mail'
require 'redis'
require 'redis/list'

#Next-Lの活動を支援するユーティリティ
module NextL
  VERSION = "0.0.3"

  autoload "EnjuRepo", File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l enju_repo }))
  autoload "Mailer", File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l mailer }))
  autoload "Mail", File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l mailer mail }))


  Config = Hash.new
  Config[:template_dir] = File.expand_path(File.join(File.dirname(__FILE__), %w{ next_l mailer templates }))

end
