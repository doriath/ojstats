set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano'
require 'capistrano_colors'

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

def run_rake(rake_task)
  run "cd '#{current_path}' && bundle exec rake RAILS_ENV=production #{rake_task}"
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

namespace :ranking do
  task :refresh do
    run_rake 'ranking:refresh'
  end

  task :refresh_all do
    run_rake 'ranking:refresh_all'
  end
end

#set :shared_children, shared_children + %w{public/uploads}

after 'deploy:update_code', 'deploy:symlink_shared'

require './config/boot'
require 'airbrake/capistrano'

desc "tail log files"
task :tail, :roles => :app do
  run "tail -f #{shared_path}/log/#{rails_env}.log" do |channel, stream, data|
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end
