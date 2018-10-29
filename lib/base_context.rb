require 'yaml'

class BaseContext
  class << self
    @functions = {}

    def start
      Dir.foreach File.expand_path("../ruby", __FILE__) { |f| BaseContext.ingest f }
    end

    def ingest f, rel_path: '', **_
      if f =~ /\.rb$/
        load_ruby path: f, rel_path: rel_path, **_
      elsif File.directory? f
        Dir.foreach f {|x| ingest x, File.expand_path(rel_path, File.basename(f))}
      else
        load_meta f, **_
      end
    end

    def load_ruby(
      path:,
      **_
    )
      return nil if path.length == 0 || (path.length == 1 && path.first == '')

      fn_path = relative_path(path)
      fn_name = fn_path.last

      if fn_name =~ /\.rb$/
        actual_path = File.join(File.dirname(__FILE__), "../../../ruby/#{fn_path.join('/')}")
      else
        actual_path = File.join(File.dirname(__FILE__), "../../../ruby/#{fn_path.join('/')}.rb")
      end

      thread          = Thread.current
      thread[:new_fn] = nil

      begin
        load actual_path
        fn = thread[:new_fn]
          # @fn_cache[fn_name] = fn
      rescue LoadError
      end

      return fn if fn && (!mode || fn.meta[:mode] == mode)
      nil
    end
  end
end

class RubyFn
  attr_accessor :meta

  def initialize **meta, &block
    @meta = meta
    @fn   = block
  end

  def matches?(
    **matches
  )
    if m = @meta[:match]
      begin
        return m.call(**matches)
      rescue
        nil
      end
    end
  end

  def call **args
    @fn.call **args
  end
end
