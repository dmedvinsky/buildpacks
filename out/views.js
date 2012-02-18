(function() {
  var init, mongo, request;

  request = require('request');

  mongo = require('mongoskin');

  init = function(app) {
    var collection, db;
    db = mongo.db(app.set('mongo_string'));
    collection = db.collection('repos');
    app.get('/', function(_, res) {
      return collection.find().toArray(function(err, items) {
        return res.render('index.haml', {
          layout: false,
          repos: items
        });
      });
    });
    app.get('/ping', function(_, res) {
      return res.send('pong\n');
    });
    app.get('/_fib/:n', function(req, res) {
      var fib, n;
      fib = function(n) {
        if (n < 2) {
          return 1;
        } else {
          return (fib(n - 2)) + (fib(n - 1));
        }
      };
      n = parseInt(req.params.n);
      return res.send(n < 10 ? "" + (fib(n)) + "\n" : 'Ugh, I forgot my calculator at home.\n');
    });
    app.get('/_refresh', function(_, res) {
      return request('https://github.com/api/v2/json/repos/search/buildpack', function(err, response, body) {
        var repos, result;
        if (!err && response.statusCode === 200) {
          result = JSON.parse(body);
          repos = result.repositories;
          repos = repos.filter(function(x) {
            return x.type === 'repo' && x.fork === false;
          });
          repos.forEach(function(x) {
            return collection.update({
              url: x.url
            }, x, {
              upsert: true
            });
          });
          return res.send("" + repos.length);
        } else {
          return res.send(err, 500);
        }
      });
    });
    return;
  };

  module.exports.init = init;

}).call(this);
