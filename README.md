#Single Page Application template

SPA template with Grunt, Bower, Backbone, Jade, CoffeeScript

##Install

1.  npm install -g bower
1.  npm install -g grunt-cli
1.  npm install
1.  bower install

##Build

grunt *[-no-dev]*

##Known issues
1. (not really issue) does not generate source map for coffeescript, because it works sucks
1. src/styles/index.styl & src/styles/mixins/mixins.styl should be exists and both must have at least 1 line of code