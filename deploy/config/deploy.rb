require 'net/ssh/kerberos'
require 'bundler/setup'
require 'bundler/capistrano'
require 'dlss/capistrano'
require 'rvm/capistrano'

set :application, "eems"
set :repository,  "ssh://corn.stanford.edu/afs/ir/dev/dlss/git/hydra/eems.git"

set :rvm_ruby_string, "1.8.7@eems"
set :rvm_type, :system


task :dev do
  role :app, "lyberapps-dev.stanford.edu"
  role :db, "lyberapps-dev.stanford.edu", :primary => true
  set :bundle_without, []                         # install all the bundler groups in dev
  set :rails_env, 'ladev'
end

task :testing do
  role :app, "lyberapps-test.stanford.edu"
  role :db, "lyberapps-test.stanford.edu", :primary => true
  set :bundle_without, []                         # install all the bundler groups in dev
  set :rails_env, 'eems-test'
end

task :production do
  role :app, "lyberapps-prod.stanford.edu"
  role :db, "lyberapps-prod.stanford.edu", :primary => true
  set :bundle_without, []                         # install all the bundler groups in dev
  set :rails_env, 'production'
end

set :shared_children, %w(log workspace db/ladev.sqlite3 db/eems-test.sqlite3 db/production.sqlite3 public/workspace config/environments config/certs config/database.yml config/solr.yml config/users.yml config/initializers/sulair_config.rb config/initializers/fedora_repository.rb )

set :destination, "/var/opt/home/lyberadmin"
set :user, "lyberadmin"
set :runner, "lyberadmin"
set :ssh_options, {:auth_methods => %w(gssapi-with-mic publickey hostbased), :forward_agent => true}

set :scm, :git
set :deploy_via, :copy
set :copy_cache, :true
set :copy_exclude, [".git"]
set :use_sudo, false
set :keep_releases, 2

set :deploy_to, "#{destination}/#{application}"

after "deploy:create_symlink", "rvm:trust_rvmrc"
after "deploy:finalize_update", "deploy:migrate"

namespace :rvm do
  task :trust_rvmrc do
    run "/usr/local/rvm/bin/rvm rvmrc trust #{latest_release}"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

