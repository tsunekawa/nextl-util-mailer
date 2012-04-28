#-*- coding:utf-8 -*-
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), %w{ .. lib}))
require 'next_l'

mailconf = NextL::Config[:mail] = YAML.load_file File.expand_path(File.join(File.dirname(__FILE__), "mailconf.test.yml"))
smtpconf = mailconf[:smtp]

Mail.defaults do
  delivery_method :test
end

