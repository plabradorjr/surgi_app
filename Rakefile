require './config/environment'
require 'sinatra/activerecord/rake'

desc 'Interactive Console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end


def reload
  load_all 'app/models'
end

