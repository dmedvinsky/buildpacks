express = require 'express'


app = express.createServer()
(require './config').init app
(require './views').init app


port = process.env.PORT || 3000
app.listen port
console.log 'Server listening on %s:%d in %s mode',
    app.address().address, app.address().port, app.settings.env
