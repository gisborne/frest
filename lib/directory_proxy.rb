using StringCall

FREST.defn(
  arg_types:   {
    path:    {'array_of' => 'string'},
    context: 'context'
  },
  result_type: 'endpoint'
) do|
  *path,
  context:,
  **c |

  result = FREST::FileLoader.load(
    **(c.merge path: path)
  )
  result&.(**c)
end
