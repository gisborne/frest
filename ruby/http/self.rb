using StringCall

$LOAD_PATH.unshift File.join(__dir__, '../..', 'lib')
require 'frest'
require 'ruby_loader'
require 'rack'
require 'uri'

FREST.defn(
  arg_types:   {
    context: 'context',
    port:    'integer'
  },
  tags:        ['service'],
  result_type: 'id',
  match:       ->(
                 **_
               ) { true }
) do |
  port: 8493,
  context:,
  **c|

  app = Proc.new do |env|
    req          = Rack::Request.new(env)
    path         = req.path_info.split('/')
    result, code = context.call(*path, **c) || ''

    code ||= 200

    if result.respond_to? :each
      [code, {}, result]
    else
      [code, {}, [result]]
    end
  end

  Rack::Handler::WEBrick.run app, Port: port
end
