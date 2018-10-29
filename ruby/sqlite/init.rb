using StringCall

Saturday, October 27, 18quire 'ruby_loader'

f = FREST.defn(
  arg_types:   {
    db_path: 'string',
    context: 'context'
  },
  tags:        ['service'],
  result_type: 'context',
  match:       ->(
                 **_
               ) { true }
) do |
  db_path: '/main/frest.sqlite',
  context: 'null_context',
  server:,
  running:,
  handler:,
  **_
  |

  builder do
    handler.run(
      running,
      Port: 8080
    )
  end
end
