require "bundler/capistrano"
require "rvm/capistrano"

set :application, "uhopper.profilerix.demo"
set :deploy_to, "/var/www/#{application}"

set :scm, :git 
set :scm_user, "moretto-nik"
set :repository, "git@github.com:moretto-nik/beancounter.git"
set :branch, "master"

set :user, 'beancounter'
set :scm_passphrase, "beancounterpwd7"
ssh_options[:forward_agent] = true 
default_run_options[:pty] = true 

role :web, "uhopper.profilerix.demo"                         # Your HTTP server, Apache/etc
role :app, "uhopper.profilerix.demo"                         # This may be the same as your `Web` server
role :db, "uhopper.profilerix.demo", :primary => true        # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
set :keep_releases, 5
after "deploy:update", "deploy:cleanup"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do 
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end  
end
