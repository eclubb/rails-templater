inject_into_file 'Gemfile', "\ngem 'compass'", :after => '### Application Gems ###'

# TODO: support more than one framework from compass
compass_sass_dir = 'app/stylesheets'
compass_css_dir = 'public/stylesheets/compiled'

compass_command = "compass init rails . --using blueprint/semantic --css-dir=#{compass_css_dir} --sass-dir=#{compass_sass_dir} "

strategies << lambda do
  puts 'Beginning Compass setup'
  run compass_command
  puts 'Compass has been setup'
end
