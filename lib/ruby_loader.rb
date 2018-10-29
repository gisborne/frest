using StringCall

require 'pry'

module FREST
  class RubyLoader
    class << self
      DEFAULT_RUBY_PATH = File.expand_path(__dir__ + '/../ruby')

      def load(
        *path,
        ruby_path: DEFAULT_RUBY_PATH,
        **args
      )
        path = relative_path(path)

        thread          = Thread.current
        thread[:new_fn] = nil

        require_relative final_path(File.join(ruby_path, path)) #rescue LoadError
        fn = thread[:new_fn]

        return fn if fn
        nil
      end

      def call(*b, **c)
        f = load(*b, **c)
        f.(*b, **c) if f
      end


      private

      def relative_path(path)
        if path.first == ''
          path[1..-1]
        else
          path
        end
      end

      def final_path(path)
        if File.directory? path
          path += '/self.rb'
        else
          path += '.rb'
        end
      end
    end
  end
end
