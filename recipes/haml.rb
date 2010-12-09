gem 'haml'
gem 'haml-rails'

remove_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.haml', load_template('app/views/layouts/application.html.haml','haml')
create_file 'app/views/shared/_flash.html.haml', load_template('app/views/shared/_flash.html.haml','haml')
