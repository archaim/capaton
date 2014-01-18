module.exports = (client) ->
  send: (event, data) ->
    if client.connected
      client.socket.emit('', {event: event, data: data})
    else
      client.sendQueue.push({event: event, data: data})