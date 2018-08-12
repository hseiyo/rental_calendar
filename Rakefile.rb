# frozen_string_literal: true

require "active_record"
require "yaml"
require "logger"
require "rspec/core/rake_task"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec, :taskargs) do |r, taskargs|
    if taskargs[:taskargs]
      case taskargs[:taskargs]
      when "nf"
        r.rspec_opts = "--next-failure"
        p "using rspec option: " + r.rspec_opts
      else
        p "unknown options: taskargs[:taskargs]"
      end
    end
  end

  # task default: :spec
rescue LoadError
  # no rspec available
end

include ActiveRecord::Tasks

db_dir = File.expand_path("db", __dir__)
config_dir = File.expand_path("config", __dir__)

DatabaseTasks.env = ENV["APP_ENV"] || "development"
DatabaseTasks.db_dir = db_dir
# DatabaseTasks.fixtures_path = "/home/vagrant/apps/rental_calendar/test/fixtures"

DatabaseTasks.database_configuration = YAML.safe_load(File.open(File.join(config_dir, "database.yml")))
DatabaseTasks.migrations_paths = File.join(db_dir, "migrate")

task :environment do
p "hello1"
p DatabaseTasks.database_configuration
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
  # ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

load "active_record/railties/databases.rake"
load "extract_fixtures.rake"

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
