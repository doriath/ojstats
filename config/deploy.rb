set :application, "ojstats"

default_run_options[:pty] = true

set :scm, :git
set :branch, 'master'
set :repository,  "git://github.com/doriath/ojstats.git"

set :ssh_options, { :forward_agent => true }

set :deploy_to, '/srv/www/ojstats'

server 'ojstats.cs.put.poznan.pl', :app, :web, :db

set :stage, :production
set :user, 'ojstats'
set :use_sudo, false

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_release}/tmp/restart.txt"
  end
end
