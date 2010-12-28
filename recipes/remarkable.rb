inject_into_file 'Gemfile', "\n  gem 'remarkable_activemodel', '>=4.0.0.alpha4'", :after => 'group :development, :test do'

after_bundler do
  inject_into_file 'spec/spec_helper.rb', "\nrequire 'remarkable/active_model'", :after => "require 'rspec/rails'"
end
