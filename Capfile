load 'deploy' if respond_to?(:namespace)

default_run_options[:pty] = true  # Must be set for the password prompt
                                  # from git to work

set :application, "semantification"

# use local repo
# set :repository, "."
set :repository, "https://github.com/theefer/semantification.git"
set :scm, "git"
set :deploy_via, :remote_cache

# set :deploy_to, "/var/www"
set :deploy_to, "/mnt/#{application}"

set :location, "ec2-54-247-28-203.eu-west-1.compute.amazonaws.com"
role :app, location
role :web, location
role :db,  location, :primary => true

set :user, "ec2-user"


namespace :nginx do
  task :start do
    run "sudo /etc/init.d/nginx start"
  end
  task :stop do
    run "sudo /etc/init.d/nginx stop"
  end
  task :restart do
    run "sudo /etc/init.d/nginx restart"
  end
end
