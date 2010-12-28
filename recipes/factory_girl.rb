gemfile = <<-END

  # Use v1.1.beta1 branch to avoid full rails dependency.
  gem 'factory_girl_rails',
      :git => 'git://github.com/thoughtbot/factory_girl_rails.git',
      :branch => 'v1.1.beta1'
END
inject_into_file 'Gemfile', gemfile, :after => 'group :development, :test do'

after_bundler do
  inject_into_file 'spec/spec_helper.rb', "\nrequire 'factory_girl'", :after => "require 'rspec/rails'"
end
