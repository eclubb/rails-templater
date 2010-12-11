gemfile = <<-END

  ### Cucumber ###
  gem 'cucumber-rails'
  gem 'capybara', '0.3.9'
  gem 'launchy'
END
inject_into_file 'Gemfile', gemfile, :before => 'end ### dev/test group ###'

strategies <<  lambda do
  generate "cucumber:install --rspec --capybara"

  cukes_factory_girl = <<-END

  require 'factory_girl'
  require 'factory_girl/step_definitions'
  Dir[File.expand_path(File.join(File.dirname(__FILE__),'..','..','spec','factories','*.rb'))].each {|f| require f}

  END

  inject_into_file 'features/support/env.rb',
    "\nCapybara.save_and_open_page_path = 'tmp/capybara/'",
    :after => 'Capybara.default_selector = :css'

  inject_into_file 'features/support/env.rb', cukes_factory_girl, :after => 'ActionController::Base.allow_rescue = false'

  if template_options[:orm] == 'datamapper'
    # DataMapper truncation strategy
    create_file 'features/support/datamapper.rb', load_template('features/support/datamapper.rb', 'datamapper')
  end
end
