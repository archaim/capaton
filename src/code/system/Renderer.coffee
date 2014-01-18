module.exports = class Renderer
  @DEFAULT_LAYOUT_ID: 'default'

  constructor: (@$container) ->
    @currentLayout = null
    @currentLayoutId = ""
    @cachedLayouts = {}
    @layouts = {}

  ###
    @param {hash} layouts
  ###
  setLayouts: (layouts, replace = true) ->
    if replace
      @layouts = layouts
      @clearCache()
    else
      @layouts = _.merge(@layouts, layouts)
      @clearCache(key) for key of layouts

    if @layouts.default
      @activateLayout(Renderer.DEFAULT_LAYOUT_ID)
    else
      c.warn 'Default layout not specified'

  clearCache: (key) ->
    if key
      @cachedLayouts[key].destroy()
      delete @cachedLayouts[key]
    else
      for key, view of @cachedLayouts
        view.destroy()
        delete @cachedLayouts[key]

  activateLayout: (layout) ->
    if !@layouts[layout]
      throw Error "Layout \"#{ layout }\" not defined"

    @currentLayout = @cachedLayouts[layout] || @cachedLayouts[layout] = new @layouts[layout]
    @currentLayoutId = layout
    @currentLayout.render()

  render: (view, layout) ->
    layout = layout || Renderer.DEFAULT_LAYOUT_ID
    if @currentLayoutId != layout
      @activateLayout(layout)

    @currentLayout.setContentView(view)
    @$container.html(@currentLayout.el)
    @currentLayout.delegateEvents()


