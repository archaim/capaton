{Base} = require 'system'
Backbone = require 'backbone'

module.exports = class Router extends Base.Router
  # Maximum URLs for history store
  @MAX_HISTORY_CAPACITY = 50

  history: []

  constructor: (@routes) ->
    super

  initialize: ->
    @route('*any', 'default', @routes['default']) if @routes['default']

    for rout, callback of @routes
      continue if rout == 'default'

      if typeof rout is 'string'
        ###
          [0] route template
          [1] name
        ###
        rout = rout.split(' : ')
        @route(rout[0], rout[1], callback)
    @

  navigate: (url, options) ->
    options = options || {}
    super
    @saveHistory(options.forceSave) if !options.replace || options.forceSave

  start: (options) ->
    options = _.merge(
      pushState: true
    , options || {})

    Backbone.history.start(options)

  ###
  Get last URL in history
  ###
  previous: ->
    @history[@history.length-1]

  ###
    Save current URL in history
    Does not save same URLs in a row by default
  ###
  saveHistory: (force) ->
    url = Backbone.history.location.pathname
    if force || url != @previous()
      @history.shift() if @history.length > Router.MAX_HISTORY_CAPACITY
      @history.push(url)
