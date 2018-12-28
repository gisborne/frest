using StringCall

require 'listen'

module FREST
  module FileLoader
    DEFAULT_SOURCE_PATH       = File.expand_path(__dir__ + '/../source')
    DEFAULT_WEAK_SOURCE_PATH  = File.expand_path(__dir__ + '/../source_weak')
    DEFAULT_PATHS             = [DEFAULT_SOURCE_PATH, DEFAULT_WEAK_SOURCE_PATH]
    DIRECTORY_PROXY           = File.expand_path(__dir__ + '/../lib/directory_proxy.rb')
    ROOT_FILE_NAME            = 'self'

    @@cache = {}


    module_function

    def load(
      path:,
      source_path: nil,
      **_
    )
      return @@cache[path]        if @@cache[path]
      return ROOT_FILE_NAME.load  if path.empty?

      source_paths = source_path ? [source_path] : DEFAULT_PATHS

      source_paths.each do |current_path|
        path = canonicalize_path([*path])

        maybe_initialize(
          source_path: current_path,
          path:        path
        )

        result = load_from_filesystem(
          path:        path,
          source_path: current_path
        )

        if result
          @@cache[path] ||= result
          return result
        end
      end

      nil
    end

    def call(*b, **c)
      f = load(*b, **c)
      f.(*b, **c) if f
    end


    # private — can't call canonicalize_path from above when private?

    def canonicalize_path(path)
      if path.first == ''
        path[1..-1]
      else
        path
      end
    end

    def maybe_initialize(
      path:,
      source_path:
    )
      if File.exist?(f = File.join(source_path, path, 'init.rb'))
        require_path f
      end
    end

    def load_from_filesystem(
      path:,
      source_path:,
      **_
    )

      thread          = Thread.current
      thread[:new_fn] = nil

      maybe_load_ruby_file(
        source_path: source_path,
        path:        path,
        thread:      thread
      ) ||
        maybe_load_other_file(
          source_path: source_path,
          path:        path
        ) ||
        nil
    end

    def maybe_load_ruby_file(
      source_path:,
      thread:,
      path:
    )
      pth = File.join(source_path, path)
      return @@cache[pth] if @@cache[pth]

      return unless ruby_file? pth


      # if (File.extname(path.last) == '') && (File.directory? pth)
      #   final_path = pth
      # else
      #   final_path = File.join(source_path, path) + '.rb'
      # end
      #
      loaded = require_path pth rescue nil

      if loaded
        fn = thread[:new_fn]

        return (@@cache[pth] = fn) if fn
      else
        false
      end
    end

    def maybe_load_other_file(
      source_path:,
      path:
    )
      p = File.join path
      return File.read(p) if File.exist? p

      asset_path = File.join('assets', *p)
      if File.file?(asset_path)
        return ->(*b, **c) { File.binread asset_path }
      else
        nil
      end
    end


    def require_path(
      path
    )
      f = final_path(path)
      require_relative f if File.exist?(f) rescue nil
    end

    def ruby_file? path
      return false if path.empty?

      ext = File.extname(path)
      ext == '.rb' || ext == ''
    end

    def exists_file? path
      File.exist? File.join(path)
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
        path += '.rb' if File.extname(path) == ''
      end

      path
    end

    Thread.new do
      Listen.to DEFAULT_SOURCE_PATH, DEFAULT_WEAK_SOURCE_PATH do |modified, added, removed|
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
