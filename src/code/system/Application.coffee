require('./syshelpers/globalRegister')(window)
config = require '../config'

{Base} = require 'system'

Router = require './Router'
Renderer = require './Renderer'

class Application extends Base.Events
  constructor: () ->
    super

  start: () ->
    @config = config
    @project = require '../project/entry'

    @router = new Router(@project.routes)
    @renderer = new Renderer($('#app'))

    @connect = require('./network/Client')(@config, require('./network/Sockets'))
    @connect.registerHandlers(@project.handlers)
    @connect.start()

    @project.beforeStart?()
    @router.start()

module.exports = App = new Application()

$ ->
  window.App = App
  App.start()