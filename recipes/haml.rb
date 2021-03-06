inject_into_file 'Gemfile', "\ngem 'haml-rails'", :after  => '### Application Gems ###'

gemfile = <<-END

  ### for html2haml ###
  gem 'hpricot'
  gem 'ruby_parser'
END
inject_into_file 'Gemfile', gemfile, :before => 'end ### dev/test group ###'

remove_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.haml', load_template('app/views/layouts/application.html.haml','haml')
create_file 'app/views/shared/_flash.html.haml', load_template('app/views/shared/_flash.html.haml','haml')
