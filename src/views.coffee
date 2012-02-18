request = require 'request'
mongous = require 'mongous'
db = mongous.Mongous


init = (app) ->
    collectionName = "#{app.set 'mongo_name'}.repos"
    collection = db collectionName

    app.get '/', (_, res) ->
        collection.find (r) ->
            # res.send r.documents
            res.render 'index.haml', {layout: false, repos: r.documents}

    app.get '/ping', (_, res) ->
        res.send 'pong\n'

    app.get '/_fib/:n', (req, res) ->
        fib = (n) -> if n < 2 then 1 else (fib n - 2) + (fib n - 1)
        n = parseInt req.params.n
        res.send if n < 10 then "#{fib n}\n" else 'Ugh, I forgot my calculator at home.\n'

    app.get '/_refresh', (_, res) ->
        request 'https://github.com/api/v2/json/repos/search/buildpack',
            (err, response, body) ->
                if not err and response.statusCode is 200
                    result = JSON.parse body
                    repos = result.repositories
                    repos = repos.filter (x) ->
                        x.type is 'repo' and x.fork is false
                    repos.forEach (x) ->
                        collection.update {url: x.url}, x, {upsert: true}
                    res.send "#{repos.length}"
                else
                    res.send err, 500

    undefined


module.exports.init = init
