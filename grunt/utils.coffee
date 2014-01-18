_ = require("lodash")

# get type-based structure of paths
module.exports.libsFiles = (libs) ->
  res = {js: {}, css: {}, fonts: {}, images: {}, assets: {}}

  getPaths = (lib, fileData) ->
    if _.isArray(fileData.file)
      _.merge({folder: folder, file: n.file}, _.omit(fileData, ['file'])) for n in fileData.file
    else if fileData.file
      _.merge({folder: folder}, fileData)
    else null

  for folder, data of libs
    for lib, path of data
      for type of res
        res[type][lib] = files if files = path[type] && getPaths(lib, path[type])
  res

# get browserify alias:alias array from output libsFiles func
module.exports.libsAdditionalAliases = (libs) ->
  res = []

  for lib, data of libs
    if _.isArray(data.alias)
      res.push("#{ lib }:#{ alias }") for alias in data.alias
    else if data.alias
      res.push("#{ lib }:#{ data.alias }")
  res

# get grunt file-object from output libsFiles func
module.exports.paths = (libs, options) ->
  options = options || {}
  destBase = ""

  if _.has(options, 'dest')
    destBase = options.dest + '/'
    delete options.dest

  for lib, data of libs
    dest = if !options.flatten then destBase + lib else destBase
    _.merge({expand: true, cwd: "#{ data.folder }/#{ lib }", src: data.file, dest: dest}, options)


# get array of simple file names from output libsFiles fun
module.exports.fileNames = (libs, options) ->
  options = options || {}

  res = []
  for lib, data of libs
    file = if options.flatten then data.file.split('/')[-1..] else data.file
    res.push(if options.map then options.map(file) else file)
  res


# get browserify aliases array from output libsFiles func
module.exports.browserifyPaths = (libs) ->
  res = []
  for lib, data of libs
    res.push("#{ data.folder }/#{ lib }/#{ data.file }:#{ lib }")
  res