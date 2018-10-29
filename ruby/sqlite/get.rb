using StringCall

Saturday, October 27, 18types:   {
    context: 'context',
    port:    'integer'
  },
  tags:        ['service'],
  result_type: 'id',
  match:       ->(
                 **_
               ) { true }
) do |
  port: 80,
  context:,
  server:,
  running:,
  handler:,
  **_|

  builder do
    handler.run(
      running,
      Port: 8080
    )
  end
end
