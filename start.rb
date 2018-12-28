#!/usr/bin/env source

require 'pathname'
require 'fileutils'

$LOAD_PATH.unshift  File.join(__dir__, 'lib')

require 'string_call'
using StringCall

require 'frest'

http          = 'http'          .load
sqlite        = 'sqlite'        .load
file_loader   = 'ruby_context'  .load
null_context  = 'null_context'  .load
user          = 'user'          .load
merge         = 'merge_contexts'.load

'pre_initialize'.call

'initialize'.call path: 'site'

handler = merge.(
  from: [
    user,
    file_loader,
    sqlite,
    null_context
  ]
)

http.(
  context: handler
)
