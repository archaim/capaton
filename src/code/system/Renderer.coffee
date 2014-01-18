module.exports = class Renderer
  constructor: (@$container) ->
    @currentLayout = null
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
      @activateLayout('default')
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

  render: (view, layout) ->
    @activateLayout(layout || 'default')

    @currentLayout.setContentView(view)
    @$container.html(@currentLayout.render().el)


