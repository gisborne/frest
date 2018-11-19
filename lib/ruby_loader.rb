using StringCall

require 'listen'

module FREST
  module RubyLoader
    DEFAULT_RUBY_PATH = File.expand_path(__dir__ + '/../ruby')
    DIRECTORY_PROXY   = File.expand_path(__dir__ + '/../lib/directory_proxy.rb')

    @@cache = {}


    module_function

    def load(
      path:,
      ruby_path: DEFAULT_RUBY_PATH,
      **_
    )
      path = canonicalize_path([*path])

      return @@cache[path] ||
        load_from_filesystem(
          path,
          ruby_path: ruby_path
        )
    end

    def call(*b, **c)
      f = load(*b, **c)
      f.(*b, **c) if f
    end


    # private

    def canonicalize_path(path)
      if path.first == ''
        path[1..-1]
      else
        path
      end
    end

    def load_from_filesystem(
      path,
      ruby_path: DEFAULT_RUBY_PATH,
      **_)

      thread          = Thread.current
      thread[:new_fn] = nil

      require_relative final_path(File.join(ruby_path, *path)) rescue nil
      fn = thread[:new_fn]

      return (@@cache[path] = fn) if fn
      nil
    end

    def final_path(path)
      if File.directory? path
        p = path + '/self.rb'
        if File.exist? p
          return p
        else
          return DIRECTORY_PROXY
        end
      else
        path += '.rb'
      end
    end

    Thread.new do
      Listen.to DEFAULT_RUBY_PATH do |modified, added, removed|
        [modified, added].each do |pth|
          if pth
            p "Reloading #{pth}"
            load_from_filesystem path: canonicalize_path(path)
          end
        end

        @@cache[canonicalize_path(removed)].delete if removed
      end
    end
  end
end
