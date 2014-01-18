module.export = (relativeTo = "") ->
  pathsToRoot =
    'system': '../'
    'project': '../'

  root = pathsToRoot[relativeTo] || ''

  {
    rootDirectory: root
    projectDirectory: root + 'project'
    systemDirectory: root + 'system'

    projectEntry: root + 'project/index.js'
  }