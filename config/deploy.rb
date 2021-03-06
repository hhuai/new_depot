require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'meimei315.com'
set :deploy_to, '/home/www/yanhua'
set :repository, 'https://github.com/hhuai/new_depot.git'
# set :repository, "/home/www/git/yanhua.git"  #直接取本地的git项目
set :branch, 'master'

set :pid_file, "#{deploy_to}/shared/tmp/pids/#{rails_env}.pid"
set :app_port, '3004'
set :app_path, lambda { "#{deploy_to}/#{current_path}"  }

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# Optional settings:
set :user, 'www'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.0.0@yanhua]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # queue! %[git push test master]
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'    
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'thin:start'
    end
  end
end

desc 'Starts the application'
task :start => :environment do
  queue "cd #{app_path} ; bundle exec rackup -s puma " +
    "-p #{app_port} -P #{pid_file} -E #{rails_env} -D"
  # queue "cd #{app_path} ; RAILS_ENV=#{rails_env} ./script/delayed_job start"
end
 
desc 'Stops the application'
task :stop => :environment do
  # queue "cd #{app_path} ; RAILS_ENV=#{rails_env} ./script/delayed_job stop"
  queue %[kill -9 `cat #{pid_file}`]
end
 
desc 'Restarts the application'
task :restart => :environment do
  invoke :stop
  invoke :start
end

namespace :passenger do
  task :restart do
    queue %{
      echo "-----> Restarting passenger"
      #{echo_cmd %[mkdir -p tmp]}
      #{echo_cmd %[touch tmp/restart.txt]}
    }
  end
end

namespace :thin do
  task :start do
    # if File.exists?('log/thin.pid')
      queue! %[bundle exec thin restart -C yanhuathin.yml]
    # else
    #   queue! %[bundle exec thin start -C yanhuathin.yml]
    # end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

