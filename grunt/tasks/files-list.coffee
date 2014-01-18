'use strict'

_ = require('lodash')

module.exports = (grunt) ->

  grunt.registerMultiTask('fileslist', 'Save files list in directory to an var', () ->
    if ! @data.destvar
      grunt.log.warn('Destination variable is not defined')
      return false

    dest = if _.isArray(@data.destvar) then @data.destvar else @data.destvar.split('.')
    grunt.config.set(dest, @filesSrc)
  )

