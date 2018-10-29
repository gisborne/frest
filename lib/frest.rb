using StringCall

require 'ruby_loader'

module FREST
  module_function

  def defn **args, &block
    Thread.current[:new_fn] = RubyFn.new **args, &block
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

  def call *path, **args
    @fn.call *path, **args
  end
end
