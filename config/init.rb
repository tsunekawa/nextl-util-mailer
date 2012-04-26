#-*- coding:utf-8 -*-
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), %w{ .. lib}))
require 'next_l'

mailconf = NextL::Config[:mail] = YAML.load_file File.expand_path(File.join(File.dirname(__FILE__), "mailconf.yml"))
smtpconf = mailconf[:smtp]

Mail.defaults do
  delivery_method :smtp, {
    :address => smtpconf[:address],
    :port => smtpconf[:port],
    :domain => smtpconf[:domain],
    :user_name => smtpconf[:user_name],
    :password  => smtpconf[:password],
    :authentication => smtpconf[:auth],
    :enable_starttls_auto => smtpconf[:tls]
  }
end

