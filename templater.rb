require File.join(File.dirname(__FILE__), 'core_extensions.rb')

initialize_templater

#Create Gemset
create_file '.rvmrc', "rvm gemset use #{app_name}"

load_options

required_recipes = %w(default jquery haml rspec factory_girl remarkable)
recipes = required_recipes

recipes << 'datamapper' if @template_options[:orm] == 'datamapper'
recipes << 'compass'    if @template_options[:compass]
recipes << 'cucumber'   if @template_options[:cucumber]
recipes << 'devise'     if @template_options[:devise]

recipes.each { |recipe_name| apply recipe(recipe_name) }

install_bundle
execute_strategies

generators_configuration = <<-END
  config.generators do |g|
      g.test_framework :rspec, :fixture => true, :webrat_matchers => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
END

application generators_configuration

git :add => '.'
git :commit => "-m 'Initial commit'"
