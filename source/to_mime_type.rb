FREST.defn(
  arg_types:   {
    path: 'string'
  },
  tags:        ['http'],
  result_type: 'http header'
) do |
  path:,
  **_|

  mime = Rack::Mime.mime_type(::File.extname(path), 'text/html')
  mime ? { "Content-Type" => mime } : {}
end

