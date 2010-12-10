gemfile = <<-END

  ### Cucumber ###
  gem 'cucumber-rails'
  gem 'capybara', '0.3.9'
  gem 'launchy'
END
inject_into_file 'Gemfile', gemfile, :before => 'end ### dev/test group ###'

generator_options = %w(--rspec --capybara)
generator_options << '--skip-database' if template_options[:orm] == 'mongoid'

strategies <<  lambda do
  generate "cucumber:install #{generator_options.join(' ')}"

  cukes_factory_girl = <<-END

  require 'factory_girl'
  require 'factory_girl/step_definitions'
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..','spec','factories','*.rb'))].each {|f| require f}

  END

  inject_into_file 'features/support/env.rb',
    "\nCapybara.save_and_open_page_path = 'tmp/capybara/'",
    :after => 'Capybara.default_selector = :css'

  inject_into_file 'features/support/env.rb', cukes_factory_girl, :after => 'ActionController::Base.allow_rescue = false'

  if template_options[:orm] == 'mongoid'
    # Mongoid truncation strategy
    create_file 'features/support/hooks.rb', load_template('features/support/hooks.rb', 'mongoid')

    # Compliment to factory_girl step definitions
    create_file 'features/step_definitions/mongoid_steps.rb', load_template('features/step_definitions/mongoid_steps.rb', 'mongoid')

    # Update mongoid.yml
    mongoid_config_path = 'config/mongoid.yml'
    gsub_file mongoid_config_path, /(test:)/,  '\1 &test'

    inject_into_file mongoid_config_path, load_snippet('database_config', 'cucumber'), :before => '# set these environment variables on your prod server'
    run "cp #{mongoid_config_path} #{mongoid_config_path}.example"
  end
end
