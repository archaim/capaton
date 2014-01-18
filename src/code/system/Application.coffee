require('./syshelpers/globalRegister')(window)
config = require '../config'

{Base} = require 'system'

Router = require './Router'
Renderer = require './Renderer'

class Application extends Base.Events
  constructor: () ->
    super
    @entry = require('../project/entry')(@)

    @router = new Router(@entry.routes)
    @renderer = new Renderer($('#app'))

  start: () ->
    @entry.beforeStart?()
    @router.start()

$ ->
  App = new Application()
  App.start()