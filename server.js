var connect = require('connect'),
http = require('http'),
modRewrite = require('connect-modrewrite');

var pkg = require('./package.json');

var options = {
    base: 'build/pkg/',
    port: 8010
}

var app = connect()

    .use(modRewrite([
        '^/$ /index.html [L]',
        '^(.+\\..*)$ /$1 [L]',
        '^.*$ /index.html'
    ]))
    .use(function(req, res, next){
        res.setHeader("Origin", "*");
        res.setHeader("X-XSS-Protection", "0");
        next();
    })
    .use(connect.static(options.base))
    .listen(options.port);

console.log('Server started at localhost:'+options.port)