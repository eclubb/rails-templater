inject_into_file 'Gemfile', "\n  gem 'rspec-rails', '~> 2.0.1'", :after => '### Rails Generators ###'

strategies << lambda do
  generate 'rspec:install'

  if template_options[:orm] == 'datamapper'
    spec_helper_path = 'spec/spec_helper.rb'

    gsub_file spec_helper_path, /(config.fixture_path = "#\{::Rails.root\}\/spec\/fixtures")/, '# \1'
    gsub_file spec_helper_path, /(config.use_transactional_fixtures = true)/, '# \1'

    inject_into_file spec_helper_path, "\n  config.before(:suite) { DataMapper.auto_migrate! }\n",
                     :after => /config.use_transactional_fixtures = true\n/
  end
end
