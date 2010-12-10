# Delete all unnecessary files
remove_file 'README'
remove_file 'public/index.html'
remove_file 'public/robots.txt'
remove_file 'public/images/rails.png'

create_file 'README'
create_file 'log/.gitkeep'
create_file 'tmp/.gitkeep'

remove_file 'Gemfile'
create_file 'Gemfile', load_template('Gemfile', 'default')

remove_file 'config/database.yml'
create_file 'config/database.yml', load_template('database.yml', 'default/config')

gsub_file 'config/application.rb', 'require "rails/test_unit/railtie"', '# require "rails/test_unit/railtie"'

get 'http://html5shiv.googlecode.com/svn/trunk/html5.js', 'public/javascripts/html5.js'

git :init

remove_file '.gitignore'
create_file '.gitignore', load_template('gitignore','git')
