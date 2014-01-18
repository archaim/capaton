App = require 'application'

module.exports =
  routes: require './routes'
  handlers:
    data: require './handlers/data'

  beforeStart: ->
    App.renderer.setLayouts(
      'default': require './views/layouts/DefaultLayout'
    )
