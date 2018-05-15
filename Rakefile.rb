require 'active_record'
require 'yaml'
require 'logger'


include ActiveRecord::Tasks

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

DatabaseTasks.env = ENV['APP_ENV'] || 'development'
DatabaseTasks.db_dir = db_dir

DatabaseTasks.database_configuration = YAML::load(File.open((File.join(config_dir, 'database.yml'))))
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
p "hello1"
p DatabaseTasks.database_configuration
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
p "hello2"
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
p "hello3"
  #ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
p "hello4"
end

load 'active_record/railties/databases.rake'

# desc "Migrate database"
# task :migrate => :environment do
#   ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
# end
# 
# task :environment do
#   dbconfig = YAML.load(ERB.new(File.read('config/database.yml')).result)
#   ActiveRecord::Base.establish_connection(dbconfig[ENV['ENV']])
#   ActiveRecord::Base.logger = Logger.new('db/database.log')
# end
