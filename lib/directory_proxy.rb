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
  **_ |

  FREST::FileLoader.load(
    path: path
  )&.()
end
