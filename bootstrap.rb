require 'rubygems'
require 'highline/import'

rvm_lib_path = "#{`echo $rvm_path`.strip}/lib"
$LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
require 'rvm'

@app_name = ARGV[0]

unless @app_name
  puts 'Usage: ruby bootstrap.rb <app_name>'
  exit
end

puts "\nCreating Rails application \"#{@app_name}\" from template\n"

rubies = RVM::list_strings

current_ruby = RVM::list_default
current_ruby = 'none' if current_ruby == nil
selected_ruby = ''

if rubies.empty?
  puts 'Error! No rubies installed in RVM!'
  exit
else
  choose do |menu|
    rubies.each do |r|
      menu.choices(r) { selected_ruby = r }
    end
    menu.prompt = 'Select RVM Ruby' + ' (default: ' + current_ruby + ')'
  end
end

gemset_name = ask("\nWhat name should the custom gemset have?" + ' (default: ' + @app_name + ')')
gemset_name = @app_name if gemset_name.empty?

@env = RVM::Environment.new(selected_ruby)

puts "\nSetting up RVM gemset and installing bundler and rails (may take a while)..."

puts "\nCreating gemset #{gemset_name} in #{selected_ruby}"
@env.gemset_create(@app_name)

@rvm = "rvm #{selected_ruby}@#{gemset_name}"

puts "\nInstalling bundler gem."
puts 'Successfully installed bundler' if system "#{@rvm} gem install --no-ri --no-rdoc bundler"

puts "\nInstalling rails gem."
puts 'Successfully installed rails' if system "#{@rvm} gem install --no-ri --no-rdoc rails"

template_file = File.join(File.expand_path(File.dirname(__FILE__)), 'templater.rb')
system "#{@rvm} exec rails new #{@app_name} -JOT -m #{template_file}"

rvmrc = File.join(@app_name, '.rvmrc')
system "echo 'rvm use #{selected_ruby}' >> #{rvmrc}"
system "echo 'rvm gemset use #{gemset_name}' >> #{rvmrc}"
system "#{@rvm} rvmrc trust #{@app_name}"
