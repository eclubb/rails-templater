module Rails
  module Generators
    module Actions

      attr_accessor :strategies
      attr_reader :template_options

      def initialize_templater
        @strategies = []
        @template_options = {}
      end

      def execute_strategies
        strategies.each {|strategy| strategy.call }
      end

      def load_options
        @template_options[:orm] = options['skip_active_record'] ? 'mongoid' : 'active_record'

        @template_options[:compass]   = yes?('Compass ? ')
        @template_options[:cucumber]  = yes?('Cucumber ? ')
      end

      def recipe(name)
        File.join File.dirname(__FILE__), 'recipes', "#{name}.rb"
      end

      def install_bundle
        gemset = `rvm info | head -n2`.split[0].chop
        run "rvm #{gemset} ruby bundle install --binstubs"
      end

      # TODO: Refactor loading of files

      def load_snippet(name, group)
        path = File.expand_path name, snippet_path(group)
        File.read path
      end

      def load_template(name, group)
        path = File.expand_path name, template_path(group)
        File.read path
      end

      def snippet_path(name)
        File.join(File.dirname(__FILE__), 'snippets', name)
      end

      def template_path(name)
        File.join(File.dirname(__FILE__), 'templates', name)
      end

    end
  end
end
