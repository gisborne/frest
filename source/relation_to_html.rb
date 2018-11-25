using StringCall

FREST.defn(
  arg_types:   {
    src:     'relation',
    context: 'context'
  },
  tags:        ['presenter'],
  result_type: 'html',
  lexical: {
    label: {
      'relation_name' => {
         src: src
      }
    }
  },
  defaults: {
    renderer: 'render_html'         .load,
    template: 'templates/reln_table'.load
   }
) do|
  context:,
  relation:,
  renderer: renderer,
  template: template,
  **_ |

  renderer.(
    context:  context,
    relation: relation,
    template: template
  )
end
