{Base} = require 'system'
t = require('templates')
module.exports = class SocketTest extends Base.View
  template: t.pages.socket
