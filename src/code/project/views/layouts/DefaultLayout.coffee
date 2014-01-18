{Base} = require 'system'

module.exports = class DefaultLayout extends Base.View
  template: require('templates').layouts.default

  views:
    'header': require './blocks/Header'
    '.content': Base.View.CONTENT
    'footer': require './blocks/Footer'

