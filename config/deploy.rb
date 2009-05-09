task :production do
  set :application, "frailers"
  set :deploy_to, "/home/www/production/#{application}"
  set :use_sudo, false
  set :scm_verbose, true
  set :rails_env, "production"
  set :user, "www-data"
  set :domain, "frailers.net"
  server domain, :app, :web
  role :db, domain, :primary => true
  set :scm, :git
  set :branch, "master"
  set :repository, "git@github.com:belighted/#{application}.git"
  set :deploy_via, :remote_cache
  namespace :passenger do
    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
    end
  end 
  namespace :deploy do
    %w(start restart).each { |name| task name, :roles => :app do passenger.restart end }
    desc "Symlink the assets directories"
    task :before_symlink do
      run "ln -s #{shared_path}/uploads                    #{release_path}/public/uploads"
      run "ln -s #{shared_path}/config/database.yml        #{release_path}/config/database.yml"
      run "ln -s #{shared_path}/config/exceptional.yml     #{release_path}/config/exceptional.yml"
      run "ln -s #{shared_path}/config/password_salt.yml   #{release_path}/config/password_salt.yml"
    end
  end
end