express = require 'express'
path = require 'path'


init = (app) ->
    app.configure ->
        app.use express.bodyParser()
        path = path.normalize __dirname + '/../static'
        app.use express.static path
        app.use express.static path + '/css'

        app.set 'mongo_host', 'localhost'
        app.set 'mongo_port', '27017'
        app.set 'mongo_name', 'buildpacks'

        app.register '.haml', require 'hamljs'

    app.configure 'development', ->
        app.use express.logger { format: ':method :url' }
        app.use express.errorHandler {dumpExceptions: true, showStack: true}

    app.configure 'production', ->
        app.use express.errorHandler()


module.exports.init = init
