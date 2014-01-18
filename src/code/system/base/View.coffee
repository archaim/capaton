Backbone = require 'backbone'

###
  View based on Backbone.View

  Extended classes should define method renderView for their render logic, but calls render for render self
###
module.exports = class View extends Backbone.View
  @CONTENT = 1

  constructor: (options = {}) ->
    # Parent view, if exists
    @parent = options.parent
    if options.el
      if options.el instanceof jQuery
        @el = options.el[0]
        @$el = options.el
      else
        @el = options.el
        @$el = $(options.el)

    # Declared selector:view field
    @views = @views || {}

    # List of current linked views
    @childViews = @childViews || {}
    super

  ###
   Self destruction
  ###
  destroy: ->
    @clearChilds()
    @remove()
    @mute()

  ###
   Remove all listening
  ###
  mute: () ->
    @off()
    @stopListening()

  ###
    Calls renderView (if exists) as method with custom render logic.
    If @renderView not exists, but @template is defined, calls simple @renderTemplate.
    After, calls renderChilds to render all nested views
  ###
  render: ->
    if @renderView
      @renderView.apply(@, arguments)
    else if @template
      @renderTemplate(@template, arguments[0])

    @renderChilds()
    @

  ###
    Create if need and render nested views
    if set rebuild - recreate all views except content view (comes from outside)
  ###
  renderChilds: (rebuild) ->
    if rebuild
      @clearChilds()

    for selector, view of @views
      if !@childViews[selector] && view != View.CONTENT
        if _.isPlainObject(view)
          @childViews[selector] =
            view: new view.view(parent: @)
          @childViews[selector].view.setData(_.result(view.data))
        else
          @childViews[selector] =
            view: new view(parent: @)
      @childViews[selector].view.render()
      @$el.find(selector).html(@childViews[selector].view.el)

    @delegateEvents()
    @

  delegateEvents: (recursively = true) ->
    if recursively
      for id, view of @childViews
        view.view.delegateEvents.apply(view.view, arguments)
    super

  ###
    Delete all created nested views
  ###
  clearChilds: ->
    for selector, value of @childViews
      # If child view created in this view - destroy it
      if @view[selector] != View.CONTENT
        value?.view?.destroy()
      delete @childViews[selector]

  renderTemplate: (template, data) ->
    @$el.html(template(data))

  setData: (@data) ->
    @trigger('change:data', @data)

  ###
    Set new view for content container. Where content container – row from @views with value @CONTENT
  ###
  setContentView: (view, options = {}) ->
    return if !(contentSelector = @getContentViewSelector())

    @childViews[contentSelector] = @childViews[contentSelector] || {}
    if options.remove
      @childViews[contentSelector].view?.destroy()

    #if !view
    @childViews[contentSelector].view = view
    @delegateEvents(false)
    @childViews[contentSelector].view.delegateEvents()
    #else
    #  @childViews[contentSelector].view = null
    #  @delegateEvents(false)

    @trigger('change:view', contentSelector)
    @trigger('change:contentview')
    @


  getContentViewSelector: ->
    for selector, value of @views
      if value == View.CONTENT
        return selector
    false
