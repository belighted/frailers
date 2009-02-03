require 'mongrel_cluster/recipes'

default_run_options[:pty] = true
set :rails_env, "production"

set :application, "frailers"
server "frailers.net", :app, :web, :db, :primary => true
set :deploy_to, "/home/www/frailers"
set :deploy_via, :remote_cache
set :scm, :git
set :repository, "git@github.com:belighted/frailers.git"
set :branch, "master"
set :user, "www-data"
set :home, "/home/www"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :use_sudo, false

task :after_update_code do
  run "ln -s #{shared_path}/uploads                    #{release_path}/public/uploads"
  run "ln -s #{shared_path}/config/database.yml        #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/config/mongrel_cluster.yml #{release_path}/config/mongrel_cluster.yml"
  run "ln -s #{shared_path}/config/exceptional.yml     #{release_path}/config/exceptional.yml"
  run "ln -s #{shared_path}/config/password_salt.yml   #{release_path}/config/password_salt.yml"
end