{Base} = require 'system'

module.exports = class Chat extends Base.Collection
  model: require '../models/Trend'