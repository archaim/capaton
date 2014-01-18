App = require 'application'

{Base} = require 'system'
t = require('templates')
module.exports = class Main extends Base.View
  template: t.pages.main

  events:
    'click #request': 'doRequest'
    'click #addColumn': 'addColumn'
    'change .trend input': 'change'
    'click .optionsMenu': 'toggleOptions'

  initialize: ->
    @trends = new (require '../../collections/Trends')
    @addColumn() for i in [0..1]
    @listenTo(@trends, 'add remove', @render)

  renderView: ->
    @renderTemplate(@template,
      trends: @trends
      maxTrends: App.config.project.maxTrends
    )

  change: (e) ->
    input = $(e.target)
    @trends.get(input.data('id')).set('request', input.val())

  doRequest: ->
    data = @trends.toJSON()
    App.connect.sender.send('data.request', data)


  addColumn: ->
    if (maxTrends = App.config.project.maxTrends) && maxTrends > @trends.length
      @trends.add({request: ""})

  toggleOptions: ->
    $('body').toggleClass('cbp-spmenu-push-toright')
    @$el.find('#options-menu').toggleClass('cbp-spmenu-open')
    @$el.find('.optionsMenu span.title').html('Hide options')
