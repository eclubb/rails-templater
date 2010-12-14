gem_name = template_options[:orm] == 'datamapper' ? 'dm-devise' : 'devise'
inject_into_file 'Gemfile', "\ngem '#{gem_name}'", :after => '### Application Gems ###'

strategies << lambda do
  generate 'devise:install'

  if template_options[:orm] == 'datamapper'
    gsub_file 'config/initializers/devise.rb', "require 'devise/orm/data_mapper'" do
      "require 'devise/orm/data_mapper_active_model'"
    end
    gsub_file 'Gemfile', /(require 'dm_validations'.*)/, '# \1'
  end

  inject_into_file 'config/environments/development.rb',
    "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }",
    :after => "config.action_mailer.raise_delivery_errors = false"

  model_name = ask('What would you like the devise User model to be called? [user]')
  model_name = 'user' if model_name.blank?

  generate('devise', model_name)

  route_string = <<-END
  devise_for :users, :path => '/', :path_names => { :sign_in => 'login', :sign_out => 'logout' } do
    root           :to => 'devise/sessions#new'
    get '/login',  :to => 'devise/sessions#new'
    get '/logout', :to => 'devise/sessions#destroy'
  end
  END
  gsub_file 'config/routes.rb', "  devise_for :#{model_name.pluralize}\n", route_string
end
