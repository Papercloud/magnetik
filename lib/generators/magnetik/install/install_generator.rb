require 'rails/generators/active_record'

class Magnetik::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer
    template 'initializer.rb', 'config/initializers/magnetik.rb'
  end

  def copy_migrations
    migration_template 'migration_customers.rb', 'db/migrate/magnetik_create_customers.rb'
    migration_template 'migration_credit_cards.rb', 'db/migrate/magnetik_create_credit_cards.rb'
  end

  # Implement the required interface for Rails::Generators::Migration.
  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    if ActiveRecord::Base.timestamped_migrations
      [Time.now.utc.strftime('%Y%m%d%H%M%S'), '%.14d' % next_migration_number].max
    else
      '%.3d' % next_migration_number
    end
  end
end
