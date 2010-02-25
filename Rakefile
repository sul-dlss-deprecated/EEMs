# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

require 'spec/rake/verify_rcov'

begin
  require 'delayed/tasks'
rescue LoadError
  STDERR.puts "Run `rake gems:install` to install delayed_job"
end

#Call this from the command line with: rake verify_rcov
RCov::VerifyTask.new(:verify_rcov => 'spec:rcov') do |t|
  t.threshold = 79.8
  t.index_html = 'coverage/index.html'
end

