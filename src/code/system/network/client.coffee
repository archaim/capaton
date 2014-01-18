{Base} = require 'system'

module.exports = (config, io) ->

  class Client extends Base.Events
    constructor: (@io) ->
      super
      @sender = require('./Sender')(@)
      @connected = false
      @handlers = []
      @sendQueue = []

      @on('connect', =>
        for i of @sendQueue
          request = @sendQueue[i]
          @sender.send(request.event, request.data)
          delete @sendQueue[i]
      )

    start: ->
      c.info 'Start socket client'
      @socket = @io.connect(config.network.host)

      @socket.on('connect', =>
        c.debug 'connected'
        connectionData = {}

        @socket.on('', (message) =>
          {event, data} = @parse(message)

          c.debug "Handle event '#{ event }': ", data

          for handlers in @handlers
            # AnyEvent hook
            if handlers['*']
              result = handlers['*'](event, data, {io: @io, socket: @socket, sender: @sender, connectionData: connectionData})
              # Stop handle event with any handler
              break if result?.abort
              # Stop handle event with current handler
              continue if result == false || result?.stop

            # Named event
            if handlers[event]
              result = handlers[event](data, {io: @io, socket: @socket, sender: @sender, connectionData: connectionData})
              break if result?.abort
        )

        @socket.on('disconnect', =>
          @connected = false
          @trigger('disconnect')
          c.debug 'disconect'
        )

        @connected = true
        @trigger('connect')
      )

    parse: (data) ->
      {
        event: data.event
        data: data.data
      }

    registerHandlers: (handlers) ->
      for id, handler of handlers
        @handlers.push(handler)

  return new Client(io)

