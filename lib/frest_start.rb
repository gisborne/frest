module FREST
  class Base
    class << self
      def start
        load_all_the_things

        start_the_things

        path = ARGV[1] || '.'
        start path: path

        b = BaseContext
        b.init

        base_content = b.fn('sqlite').call(
          path: ''
        )
        http_server  = b.fn('http')
        web_renderer = b.fn('html')
        storage      = b.fn('sqlite')
        chain        = b.fn('chain_context').call(
          content: [storage, web_renderer]
        )


        http_server.call(
          path:    'start',
          context: chain
        )
      end

      private

      def load_all_the_things
        Dir.glob 'source/**/*.rb' do |f|
          require Dir.f
        end
      end

      def start_wanted_things
        'http/local/running'.()
      end
    end
  end
end
