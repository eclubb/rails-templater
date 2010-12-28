inject_into_file 'Gemfile', "\n  gem 'jquery-rails'", :after => '### Rails Generators ###'

gsub_file 'config/application.rb', /(config.action_view.javascript_expansions\[:defaults\] = %w\(\))/, '# \1'

after_bundler do
  generate 'jquery:install --ui' # to enable jQuery UI
end
