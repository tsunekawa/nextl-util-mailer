require 'rake'
require 'rspec/core'
require 'rspec/core/rake_task'

desc "spec test"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-fs --color --require spec_helper.rb']
end

task :default  => :spec
