using StringCall
require 'frest'

FREST.defn do
|
from:,
  **_|

  ContextMerger.new(from)
end


class ContextMerger
  def initialize contexts
    @contexts = [*contexts]
  end

  def call path, **c
    @contexts.reverse_each do |cont|
      result = cont.call(
        *path,
        mode: :strong,
        **c
      )
      return result if result
    end

    @contexts.each do |cont|
      result = cont.call(
        *path,
        mode: :weak,
        **c
      )
      return result if result
    end
  end
end
