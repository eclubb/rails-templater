inject_into_file 'Gemfile', "\n  gem 'rspec-rails', '~> 2.0.1'", :after => '### Rails Generators ###'

strategies << lambda do
  generate 'rspec:install'

  spec_helper_path = 'spec/spec_helper.rb'

  gsub_file spec_helper_path, 'config.fixture_path = "#{::Rails.root}/spec/fixtures"', ''
  gsub_file spec_helper_path, /(config.use_transactional_fixtures = true)/, '# \1'
end
