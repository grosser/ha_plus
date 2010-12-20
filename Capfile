load "deploy"
require 'bundler/capistrano'

set :application, "HAPlus"

set :scm, :git
set :repository, "git@github.com:grosser/ha_plus.git"
set :branch, ENV['BRANCH'] || "master"

set :deploy_to, '/srv/ha_plus'

set :user, 'deploy'
ssh_options[:keys] = "~/.ssh/deploy_id_rsa"
set :use_sudo, false

# production or staging ?
task(:production){}
set :stage, (ARGV.first == 'production' ? :production : :staging)
CFG = YAML.load(File.read('config.yml'))

ips = CFG['deploy'][stage.to_s]
ips.each do |ip|
  role :app, ip
  role :web, ip
end 

namespace :deploy do
  task :start do
    run "cd #{current_path} && bundle exec thin start --daemonize --port 8701"
  end

  task :stop do
    pid = 'tmp/pids/thin.pid'
    run "cd #{current_path} && (test -e #{pid} && cat #{pid} | xargs kill --no-run-if-empty) || echo 'not running'"
  end

  task :restart, :roles => :app do
    unless ENV['NO_RESTART']
      stop
      start
    end
  end

  task :copy_config_files do
    run "cp #{deploy_to}/shared/*.yml #{current_release}/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'
end
after "deploy", "deploy:cleanup"