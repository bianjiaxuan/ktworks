# require 'capistrano_colors'
require 'bundler/capistrano'
require "rvm/capistrano"
#require 'capistrano/maintenance'

#_cset(:unicorn_conf) { "#{current_path}/config/unicorn.rb" }

set :deploy_via, :remote_cache

# set :repository,  'git@github.com:Blowdy/kt.git'
set :repository,  'git@bitbucket.org:yoshikizh/kicktempo.git'
# set :repository,  'kicktempo@183.60.158.8:kicktempo_repo'

set :scm, :git
#set :scm_username,   "root"

set :default_run_options, :pty => true
ssh_options[:paranoid] = false
#ssh_options[:forward_agent] = true

#set :user,       "root"
set :port, "22"
set :use_sudo, true

#set :user, 'deployer'
#set :group, "staff"
#set :runner, "deployer"

set :rails_env,  'production'

set :rvm_ruby_string, 'ruby-2.1.0@kick'
set :rvm_type, :system

set :bundle_without, [:development, :test]
set :normalize_asset_timestamps, false

set :default_stage, "master"

set :branch, "master"
#set :deploy_env, 'production'
#set :application, "kicktempo_production"
#set :deploy_to,   "/var/www/kicktempo.git"
set :rails_env, 'production'

# set :keep_releases, 5

# set :deploy_via, :copy_with_bundle_package
# set :copy_cache, true
# set :copy_exclude, '.git*'

# default_run_options[:pty] = true
# default_environment['PATH'] = "/home/deployer/.rbenv/bin:/home/deployer/.rbenv/shims:$PATH"

# role :app, '120.92.246.200'
# role :web, '120.92.246.200'
# role :db,  '120.92.246.200', :primary => true

task :staging do
  server "114.215.170.230", :app, :web, :db, :primary => true
  set :user,           "root"
  set :scm_username,   "root"
  set :scm_passphrase, "bc0f9242"
  set :scm_password,   "bc0f9242"
  set :password,       "bc0f9242"
  set :deploy_env, 'staging'
  set :application, "kicktempo_staging"
  set :deploy_to,   "/var/www/kicktempo.git"
end

task :production do
  server "114.215.179.58", :app, :web, :db, :primary => true
  set :user,           "root"
  set :scm_username,   "root"
  set :scm_passphrase, "4eeb0365"
  set :scm_password,   "4eeb0365"
  set :password,       "4eeb0365"
  set :deploy_env, 'production'
  set :application, "kicktempo_production"
  set :deploy_to,   "/var/www/kicktempo.git"
end

before 'deploy:finalize_update', :roles => :app do
  run "ln -s #{shared_path}/public/ckeditor_assets #{release_path}/public/"
  run "ln -s #{shared_path}/public/images #{release_path}/public/"
  run "ln -s #{shared_path}/public/uploads #{release_path}/public/"
  run "ln -s #{shared_path}/uploadfiles #{release_path}/public/"

  db_config = "#{shared_path}/config/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"

  unicorn_config = "#{shared_path}/unicorn.rb"
  run "cp #{unicorn_config} #{release_path}/config/unicorn.rb"
end

namespace :deploy do
  desc "Deploy your application"

  # task :update_symlink do
  #   run "ln -s #{shared_path}/uploads #{release_path}/public"
  # end

  task :copy_config_files do
    db_config = "#{shared_path}/config/database.yml"
    run "cp #{db_config} #{release_path}/config/database.yml"
  end


  task :copy_unicorn_config_file do
    unicorn_config = "#{shared_path}/unicorn.rb"
    run "cp #{unicorn_config} #{release_path}/config/unicorn.rb"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "kill -USR2 `cat /var/www/kicktempo.git/shared/pids/unicorn.pid`"
  end

  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -HUP `cat /var/www/kicktempo.git/shared/pids/unicorn.pid`"
  end

  task :bundle_install, :roles => :app do
    # run "cd #{release_path} && bundle install --deployment --quiet --without development test"
    run "cd #{release_path} && bundle install"
  end
end

namespace :back_up do
  task :database, :roles => :app do
    dbpw = 'kick2013'
    run "mysqldump -u root -p#{dbpw} -h localhost kick > /home/kicktempo/backup_dbs/tisdb_dump.sql"
    run "mv /home/kicktempo/backup_dbs/tisdb_dump.sql `date '+/home/kicktempo/backup_dbs/tisdb_dump-%Y%m%d%H%M.sql'`"
  end
end

# after 'deploy:finalize_update', 'back_up:database'
# after 'back_up:database', 'deploy:migrate'

after 'deploy:restart', 'deploy:cleanup'
after "deploy:update_code", "deploy:copy_config_files"
after "deploy:update_code", "deploy:copy_unicorn_config_file"
# after "deploy:finalize_update", "deploy:update_symlink"

