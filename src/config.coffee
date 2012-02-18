express = require 'express'
path = require 'path'


init = (app) ->
    app.configure ->
        app.use express.bodyParser()
        path = path.normalize __dirname + '/../static'
        app.use express.static path
        app.use express.static path + '/css'

        app.set 'mongo_string', 'mongodb://heroku:12345678@staff.mongohq.com:10077/buildpacks'

        app.register '.haml', require 'hamljs'

    app.configure 'development', ->
        app.use express.logger { format: ':method :url' }
        app.use express.errorHandler {dumpExceptions: true, showStack: true}

    app.configure 'production', ->
        app.use express.errorHandler()


module.exports.init = init
