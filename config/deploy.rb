CONFIG = YAML::load_file(File.join('config','config.yml'))

task :production do
  set :application, "frailers"
  set :deploy_to, "/home/production/#{application}"
  set :use_sudo, false
  set :scm_verbose, true
  set :rails_env, "production"
  set :user, CONFIG["production"]["deployment"]["user"]
  set :domain, CONFIG["production"]["deployment"]["domain"]
  set :port, CONFIG["production"]["deployment"]["port"]
  server domain, :app, :web
  role :db, domain, :primary => true
  set :scm, :git
  set :branch, "master"
  set :repository, "git@github.com:belighted/frailers.git"
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
      run "ln -s #{shared_path}/config/config.yml          #{release_path}/config/config.yml"
    end
  end
end