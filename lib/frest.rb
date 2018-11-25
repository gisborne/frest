using StringCall

require 'file_loader'

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
    else
      true
    end
  end

  def call *path, **args
    @fn.call *path, context: self, **args
  end
end
