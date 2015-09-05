fs          = require 'fs'
express     = require 'express'
app         = express()
http        = require 'http'
{join}      = require 'path'
bodyParser  = require 'body-parser'

app.use bodyParser.json()

PORT = Number process.env.PORT or 3011

app.use express.static join __dirname, 'resources'

app.get '/', (request, response, next) ->
  indexPage = join __dirname, 'resources/index.html'
  response.status 200
    .sendFile indexPage

httpServer = http.createServer app

httpServer.listen PORT, ->
  console.log 'SERVER RUNNING ON ' + PORT