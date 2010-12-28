inject_into_file 'Gemfile', "\ngem 'compass'", :after => '### Application Gems ###'

# TODO: support more than one framework from compass
compass_sass_dir = 'app/stylesheets'
compass_css_dir = 'public/stylesheets/compiled'
compass_syntax = 'sass'

compass_command = 'compass init rails . --using blueprint/semantic ' +
                  "--syntax=#{compass_syntax} " +
                  "--css-dir=#{compass_css_dir} " +
                  "--sass-dir=#{compass_sass_dir}"

after_bundler do
  run compass_command

  inject_string = <<-END
    = stylesheet_link_tag 'compiled/screen.css', :media => 'screen, projection'
    = stylesheet_link_tag 'compiled/print.css', :media => 'print'

    /[if lt IE 8]
      = stylesheet_link_tag 'compiled/ie.css', :media => 'screen, projection'
  END
  gsub_file 'app/views/layouts/application.html.haml',
    "    = stylesheet_link_tag :all\n",
    inject_string
end
