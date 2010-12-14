gemfile = <<-END
### DataMapper ###
DM_VERSION    = '~> 1.0.2'

gem 'dm-rails',          '~> 1.0.4'
gem 'dm-sqlite-adapter', DM_VERSION

gem 'dm-migrations',     DM_VERSION
gem 'dm-types',          DM_VERSION
# gem 'dm-validations',  DM_VERSION
# gem 'dm-constraints',  DM_VERSION
gem 'dm-transactions',   DM_VERSION
gem 'dm-aggregates',     DM_VERSION
gem 'dm-timestamps',     DM_VERSION
# gem 'dm-observer',     DM_VERSION

END
inject_into_file 'Gemfile', gemfile, :before => '### Application Gems ###'

gsub_file 'Gemfile', "gem 'sqlite3-ruby', :require => 'sqlite3'\n\n", ''
gsub_file 'Gemfile', "gem 'activerecord',   RAILS_VERSION, :require => 'active_record'\n", ''

inject_into_file 'config/application.rb',
                 "\nrequire \"dm-rails/railtie\"",
                 :after => 'require "action_controller/railtie"'

gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
  "# config.action_mailer.raise_delivery_errors = false"
end

gsub_file 'config/environments/test.rb', /config.action_mailer.delivery_method = :test/ do
  "# config.action_mailer.delivery_method = :test"
end
create_file 'lib/tasks/datamapper_noops.rake', load_template('lib/tasks/datamapper_noops.rake', 'datamapper')

inject_into_file  'app/controllers/application_controller.rb',
                  "require 'dm-rails/middleware/identity_map'\n\n",
                  :before => 'class ApplicationController'

inject_into_class 'app/controllers/application_controller.rb',
                  'ApplicationController',
                  "  use Rails::DataMapper::Middleware::IdentityMap\n\n"
