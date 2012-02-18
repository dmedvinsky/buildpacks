(function() {
  var express, init, path;

  express = require('express');

  path = require('path');

  init = function(app) {
    app.configure(function() {
      app.use(express.bodyParser());
      path = path.normalize(__dirname + '/../static');
      app.use(express.static(path));
      app.set('mongo_string', 'mongodb://heroku:12345678@staff.mongohq.com:10077/buildpacks');
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
