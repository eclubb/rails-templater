require File.join(File.dirname(__FILE__), 'core_extensions.rb')

initialize_templater

load_options

required_recipes = %w(default jquery haml rspec factory_girl remarkable)
recipes = required_recipes

recipes << 'datamapper' if @template_options[:orm] == 'datamapper'
recipes << 'compass'    if @template_options[:compass]
recipes << 'cucumber'   if @template_options[:cucumber]
recipes << 'devise'     if @template_options[:devise]

recipes.each { |recipe_name| apply recipe(recipe_name) }

inside app_name do
  run 'bundle install'
end

execute_after_bundle

generators_configuration = <<-END
  config.generators do |g|
      g.test_framework :rspec, :fixture => true, :webrat_matchers => true
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.stylesheets false
    end
END

application generators_configuration

git :init

remove_file '.gitignore'
create_file '.gitignore', load_template('gitignore','git')

git :add => '.'
git :commit => "-m 'Initial commit'"
