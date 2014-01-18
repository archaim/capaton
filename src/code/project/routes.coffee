App = require 'application'

module.exports =
  default: ->
    App.connect.sender.send('user.login', {id: 313})

    view = new (require './views/pages/Main')
    App.renderer.render(view)


