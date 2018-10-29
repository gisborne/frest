#!/usr/bin/env ruby

require 'pathname'
require 'fileutils'

$LOAD_PATH.unshift  File.join(__dir__, 'lib')

require 'string_call'
using StringCall
require 'frest'

http          = 'http'          .load
sqlite        = 'sqlite'        .load
ruby_loader   = 'ruby_context'  .load
null_context  = 'null_context'  .load
user          = 'user_context'  .load

merge         = 'merge_contexts'.load

handler = merge.(
  from: [
    user,
    ruby_loader,
    sqlite,
    null_context
  ]
)

http.(
  context: handler
)
