module.exports = (App) ->
  routes: require('./routes')(App)

  beforeStart: ->
    App.renderer.setLayouts(
      'default': require './views/layouts/DefaultLayout'
    )
