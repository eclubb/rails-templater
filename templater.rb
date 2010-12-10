require File.join(File.dirname(__FILE__), 'core_extensions.rb')

initialize_templater

#Create Gemset
create_file '.rvmrc', "rvm gemset use #{app_name}"

load_options

#required_recipes = %w(default jquery haml rspec factory_girl remarkable)
required_recipes = %w(default jquery haml rspec factory_girl)
recipes = required_recipes

recipes << 'compass'  if @template_options[:compass]
recipes << 'cucumber' if @template_options[:cucumber]

recipes.each { |recipe_name| apply recipe(recipe_name) }

install_bundle
execute_strategies

generators_configuration = <<-END
config.generators do |g|
  g.test_framework :rspec, :fixture => true, :webrat_matchers => true
  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
  g.stylesheets false
end
END

environment generators_configuration

git :add => '.'
git :commit => "-m 'Initial commit'"
