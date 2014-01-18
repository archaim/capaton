###
  TODO: dependencies for css files
  TODO: watch mode
  TODO: clean up the mess in config.paths
###

_ = require 'lodash'
utils = require("./grunt/utils")

libs = require './grunt/libs.coffee'

module.exports = (grunt) ->
  config =
    pkg: require './package.json'
    isDev: grunt.option('no-dev')

    paths:
      dist: 'build/pkg'
      tmp: 'build/tmp'

      js: 'js'
      css: 'styles'
      images: 'images'
      fonts: 'fonts'
      assets: 'assets'
      vendors: 'vendors'
      generated: 'generated'

      source: 'src'
      code: 'code'
      layouts: 'layouts'
      templates: 'templates'

      templatesjs: 'templates.js'
      minifedjs: 'app.js'
      stylecss: 'styles.css'

  grunt.initConfig _.merge config,
    clean:
      dist: ['<%= paths.dist %>']
      tmp: ['<%= paths.tmp %>']

    coffeelint:
      options:
        max_line_length:
          value: 140
      full: ['<%= paths.source %>/<%= paths.code %>/**/*.coffee']

    coffee:
      compile:
        options:
          sourceMap: false && config.isDev
        files: [
          {expand: true, cwd: '<%= paths.source %>', src: ['<%= paths.code %>/**/*.coffee'], dest: '<%= paths.tmp %>/<%= paths.js %>', ext: '.js'}
        ]

    replace:
      templates:
        ###
          Fix generated jade templates
          * Remove namespace creation
          * Add jade runtime import
          * Add lodash
          * Add makeNested helper
          * Make it browserify compatible
        ###
        src: ['<%= paths.tmp %>/<%= paths.js %>/<%= paths.generated %>/<%= paths.templatesjs %>'],
        overwrite: true
        replacements: [{
          from: ///this\[.*\]\s=\sthis\[.*\].*;///,
          to: grunt.file.read('grunt/includes/templates.js')
        },{
          from: ///this\[.*\]\["(.*)"\]\s=///gm,
          to: 'makeNested(module.exports, "$1"); module.exports.$1 ='
        }]

    browserify:
      dist:
        options:
          debug: config.isDev
          alias: utils.browserifyPaths(libs.js, {cwd: './<%= isDev ? paths.dist : paths.tmp  %>/<%= paths.js %>/<%= paths.vendors %>', flatten: true})
                 .concat(utils.libsAdditionalAliases(libs.js))
                 .concat(['<%= paths.tmp %>/<%= paths.js %>/<%= paths.generated %>/<%= paths.templatesjs %>:templates'])
                 .concat(['<%= paths.tmp %>/<%= paths.js %>/<%= paths.code %>/system/bundles/system.js:system'])
          transform: ['coffeeify']
        src: [
          '<%= paths.tmp  %>/<%= paths.js %>/<%= paths.code %>/**/*.js'
          '<%= paths.tmp  %>/<%= paths.js %>/<%= paths.generated %>/**/*.js'
          #'<%= isDev ? paths.dist : paths.tmp  %>/<%= paths.js %>/**/*.js'
        ]
        dest: '<%= paths.dist %>/<%= paths.js %>/<%= paths.minifedjs %>'

    uglify:
      dist:
        files:
          '<%= paths.dist %>/<%= paths.js %>/<%= paths.minifedjs %>': ['<%= paths.dist %>/<%= paths.js %>/<%= paths.minifedjs %>']

    jade:
      options:
        pretty: grunt.option('no-beautifyHtml')
        compileDebug: config.isDev
      layouts:
        options:
          data:
            debug: config.isDev
        files: [
          expand: true, flatten: true, src: ['<%= paths.source %>/<%= paths.layouts %>/**/*.jade', '!**/_*'], dest: '<%= paths.dist %>', ext: '.html'
        ]
      templates:
        options:
          data:
            debug: config.isDev
          client: true
          processName: (filePath) ->
            (filePath = filePath.replace("#{ config.paths.source }/#{ config.paths.templates }/",''))[...filePath.lastIndexOf('.')].split('/').join('.')
        files:
          '<%= paths.tmp %>/<%= paths.js %>/<%= paths.generated %>/<%= paths.templatesjs %>': [
            '<%= paths.source %>/<%= paths.templates %>/**/*.jade'
            '!<%= paths.source %>/<%= paths.templates %>/mixins/**/*.jade'
            '!<%= paths.source %>/<%= paths.templates %>/**/_*'
          ]

    copy:
      styles:
        files: [
          {expand: true, cwd: '<%= paths.tmp %>', src: ['<%= paths.css %>/**/*'], dest: '<%= paths.dist %>'}
        ]
      libsAssets:
        files: (utils.paths(libs.css, {dest: '<%= isDev ? paths.dist : paths.tmp %>/<%= paths.css %>', flatten: true}) || [])
        .concat(utils.paths(libs.fonts, {dest: '<%= paths.dist %>/<%= paths.fonts %>', flatten: true}) || [])
        .concat(utils.paths(libs.images, {dest: '<%= paths.dist %>/<%= paths.images %>', flatten: true}) || [])
        .concat(utils.paths(libs.assets, {dest: '<%= paths.dist %>/<%= paths.assets %>', flatten: true}) || [])

    stylus:
      options:
        linenos: config.isDev
        paths: ['<%= paths.source %>/<%= paths.css %>/mixins'],
        import: ['mixins'],
        compress: !config.isDev
      compile:
        files:
          '<%= paths.tmp %>/<%= paths.css %>/<%= paths.stylecss %>': [
            '<%= paths.source %>/<%= paths.css %>/index.styl'
            '!<%= paths.source %>/<%= paths.css %>/mixins/**/*'
            '!<%= paths.source %>/<%= paths.css %>/**/_*'
          ]

    cssmin:
      dist:
        files:
          '<%= paths.dist %>/<%= paths.css %>/<%= paths.stylecss %>' : ['<%= paths.tmp %>/<%= paths.css %>/**/*.css']

    fileslist:
      styles:
        destvar: 'jade.layouts.options.data.styles'
        files: [
          cwd: '<%= paths.dist %>'
          src: utils.fileNames(libs.css, {flatten: true, map: (f) -> "<%= paths.css %>/#{ f }"})
          .concat(['<%= paths.css %>/<%= paths.stylecss %>'])
        ]
      scripts:
        destvar: 'jade.layouts.options.data.scripts'
        files: [
          cwd: '<%= paths.dist %>'
          src: ['<%= paths.js %>/**/*']
        ]

    watch:
      full:
        files: ['<%= paths.source %>/**/*']
        tasks: ['rebuild']



  grunt.loadTasks('grunt/tasks')
  require('load-grunt-tasks')(grunt)

  grunt.registerTask '_clean', ['clean:dist', 'clean:tmp']

  grunt.registerTask '_layouts', ['fileslist', 'jade:layouts']

  grunt.registerTask '_templates', ['jade:templates', 'replace:templates']

  grunt.registerTask '_makecoffee', _.flatten([
    'coffeelint:full',
    'coffee:compile',
    if config.isDev then ['browserify:dist'] else ['browserify:dist', 'uglify:dist']
  ])

  grunt.registerTask '_makestyles', _.flatten([
    'stylus:compile',
    if config.isDev then ['copy:styles'] else ['cssmin:dist']
  ])

  grunt.registerTask '_compile', ['_templates', '_makecoffee', '_makestyles', '_layouts']

  grunt.registerTask 'rebuild', ['_clean', 'copy:libsAssets', '_compile']

  grunt.registerTask 'default', ['rebuild']