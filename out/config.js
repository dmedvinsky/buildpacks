(function() {
  var express, init, path;

  express = require('express');

  path = require('path');

  init = function(app) {
    app.configure(function() {
      app.use(express.bodyParser());
      path = path.normalize(__dirname + '/../static');
      app.use(express.static(path));
      app.use(express.static(path + '/css'));
      app.set('mongo_host', 'localhost');
      app.set('mongo_port', '27017');
      app.set('mongo_name', 'buildpacks');
      return app.register('.haml', require('hamljs'));
    });
    app.configure('development', function() {
      app.use(express.logger({
        format: ':method :url'
      }));
      return app.use(express.errorHandler({
        dumpExceptions: true,
        showStack: true
      }));
    });
    return app.configure('production', function() {
      return app.use(express.errorHandler());
    });
  };

  module.exports.init = init;

}).call(this);
