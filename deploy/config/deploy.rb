require 'net/ssh/kerberos'
require 'bundler/setup'
require 'bundler/capistrano'
require 'dlss/capistrano'

set :application, "eems"
set :repository,  "ssh://corn.stanford.edu/afs/ir/dev/dlss/git/hydra/eems.git"

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

after "deploy:finalize_update", "deploy:migrate"

# Stop
before "deploy:update", "eems:stop_delayed_job"

# If anything goes wrong, undo.
before "deploy:rollback", "eems:stop_delayed_job"
after "deploy:rollback", "eems:start_delayed_job"

namespace :eems do
  def run_dj_cmd(script)
    cmd = "cd #{current_path}; /usr/local/rvm/gems/ruby-1.8.7-p334/bin/bundle exec ./#{script} #{rails_env}"
    run cmd
  end

  task :start_delayed_job do
    run_dj_cmd "startjob.sh"
  end

  task :stop_delayed_job do
    run_dj_cmd "stopjob.sh" if(released)
  end
end

# :released is true if there are any deployed releases, false otherwise
# Prevents capistrano from stopping the robots if the project hasn't been deployed yet
set(:released) { capture("ls -x #{releases_path}").split.length > 0 }

namespace :deploy do
  task :start do
    eems.start_delayed_job
  end

  task :stop do
    eems.stop_delayed_job
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :default do
    update
    start
  end
end
