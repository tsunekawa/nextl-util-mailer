require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'

TMP_DIR = "./tmp"
directory TMP_DIR

desc "spec test"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-fs --color --require spec_helper.rb']
end
task :spec =>["redis:test:restart"]
task :default  => :spec

namespace :redis do

  namespace :test do
    desc "start redis server for test"
    task :start =>[TMP_DIR] do
      sh "redis-server config/redis.test.conf"
    end

    desc "stop redis server for test"
    task :stop do
      sh "kill `cat ./tmp/redis.test.pid`" if File.exists? "./tmp/redis.test.pid"
    end

    desc "restart redis server for test"
    task :restart =>[:stop,:start]
  end

  namespace :production do
    desc "start redis server for test"
    task :start =>[TMP_DIR] do
      sh "redis-server config/redis.production.conf"
    end

    desc "stop redis server for test"
    task :stop do
      sh "kill `cat ./tmp/redis.production.pid`"
    end

    desc "restart redis server for test"
    task :restart =>[:stop,:start]
  end
end
