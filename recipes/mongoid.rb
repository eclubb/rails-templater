gemfile = <<-END
gem 'mongoid', '2.0.0.beta.20'
gem 'bson_ext', '~> 1.1.2'
END
inject_into_file 'Gemfile', gemfile, :after  => "### Application Gems ###\n"

strategies << lambda do
  generate 'mongoid:config'

  run 'cp config/mongoid.yml config/mongoid.yml.example'
end
