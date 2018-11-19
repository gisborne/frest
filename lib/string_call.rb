module StringCall
  refine String do
    def call(**args)
      begin
        FREST::RubyLoader.call(self, **args)
      rescue Exception => e
        raise e
      end
    end

    def load(**args)
      FREST::RubyLoader.load(path: self, **args)
    end
  end
end
