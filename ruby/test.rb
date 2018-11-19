using StringCall

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
) do
  |
  **_ |

  'foo'
end
