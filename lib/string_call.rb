module StringCall
  refine String do
    def call(**args)
      begin
        FREST::FileLoader.call(**(args.merge(path: self)))
      rescue Exception => e
        raise e
      end
    end

    def load(**args)
      FREST::FileLoader.load(path: self, **args)
    end
  end
end
