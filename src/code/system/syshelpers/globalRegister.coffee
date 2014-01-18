###
  Register some libraries in global namespace
###

module.exports = (root) ->
  Backbone = require 'backbone'

  root.$ = root.jQuery = require('jquery')
  root._ = require 'lodash'
  root.c = console
  root.WEB_SOCKET_SWF_LOCATION = '/assets/'

  Backbone.$ = root.$

  require 'bootstrap'



