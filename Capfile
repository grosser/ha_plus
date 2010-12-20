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
CFG = Yaml.load(File.read('config.yml'))

ip = CFG['deploy'][stage.to_s]
role :app, ip
role :web, ip

namespace :deploy do
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt" unless ENV['NO_RESTART']
  end

  task :copy_config_files do
    run "cp #{deploy_to}/shared/*.yml #{current_release}/"
  end
  after 'deploy:update_code', 'deploy:copy_config_files'
end
after "deploy", "deploy:cleanup"