#-*- coding:utf-8 -*-
require "./config/init"
require 'sinatra'

get '/issues' do
  NextL::Mailer.new.deliver_issues(:limit=>(params[:limit] || 5).to_i)
end

run Sinatra::Application
