module.exports = (App) ->
  default: ->
    view = require './views/pages/SocketTest'
    view = new view
    App.renderer.render(view)

  'main : main': ->
    io = require('socket.io-client')
    socket = io.connect('http://'+$('#addr').val())
    socket.on('connect', ->
      c.log 'connected'
      socket.emit('', "some data")
      socket.emit('m', "some data")
      socket.on('anything', (data) -> c.log arguments)
      socket.on('', (data) -> c.log arguments)
      socket.on('disconnect', -> c.debug 'disconect')
    )


