module StringCall
  refine String do
    def call(**args)
      begin
        FREST::FileLoader.call(path: self, **args)
      rescue Exception => e
        raise e
      end
    end

    def load(**args)
      FREST::FileLoader.load(path: self, **args)
    end
  end
end
