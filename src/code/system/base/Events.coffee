Backbone = require 'backbone'

###
  Backbone.Events wraper for "extends" use
###
module.exports = class Events
  constructor: ->
    _.extend @__proto__, Backbone.Events