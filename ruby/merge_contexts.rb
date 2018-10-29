using StringCall
require 'frest'

FREST.defn do
  |
  from:,
  **_ |

  ContextMerger.new(from)
end


class ContextMerger
  def initialize contexts
    @contexts = [*contexts]
  end

  def call(
    *path,
    **c
  )
    @contexts.each do |cont|
      result = cont.call(*path, **c)
      return result if result
    end

    nil
  end
end
