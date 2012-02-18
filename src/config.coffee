express = require 'express'
path = require 'path'


init = (app) ->
    app.configure ->
        app.use express.bodyParser()
        path = path.normalize __dirname + '/../static'
        app.use express.static path

        app.set 'mongo_string', 'mongodb://localhost:27017/buildpacks'

        app.register '.haml', require 'hamljs'

    app.configure 'development', ->
        app.use express.logger { format: ':method :url' }
        app.use express.errorHandler {dumpExceptions: true, showStack: true}

    app.configure 'production', ->
        app.use express.errorHandler()


module.exports.init = init
