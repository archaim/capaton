{libsFiles} = require("./utils")

components =
  "bower_components":
      ###
        Required libs
      ###
      jade:
        js:
          file: "lib/runtime.js"
      lodash:
        js:
          file: "dist/lodash.js"
          alias: "underscore"

      ###
        Optional libs
      ###
      jquery:
        js:
          file: "jquery.js"
      bootstrap:
        js:
          file: "dist/js/bootstrap.js"
        css:
          file: "dist/css/bootstrap.css"
        fonts:
          file: "dist/fonts/*"
      backbone:
        js:
          file: "backbone.js"
      rivets:
        js:
          file: "dist/rivets.js"
      "socket.io-client":
        js:
          file: "dist/socket.io.js"
        assets:
          file: "dist/*.swf"

  ###
    Libs that don't exists in bower repo, git, or that need monkey patching for work with browserify/other libs
  ###
  "components":
    "backbone-relational":
      js:
        file: "backbone-relational.js"


module.exports = libsFiles(components)