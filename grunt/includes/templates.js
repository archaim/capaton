/* Templates */

jade = require('jade');
_ = require('lodash');

function makeNested(obj, path) {
    if(!_.isPlainObject(obj))
        obj = {}

    var levels = path.split('.');
    var root = obj;
    for (var i = 0, level = ""; i < levels.length - 1; i++) {
        var level = levels[i];
        if(!_.isPlainObject(root[level]))
            root[level] = {}
        root = root[level]
    }
}
