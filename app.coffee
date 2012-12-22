"use strict"
express = require 'express'
http = require 'http'
path = require 'path'

{ControllerBridge} = require './lib'

app = do express

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set 'controllers', __dirname + '/controllers'
  app.use do express.favicon
  app.use express.logger 'dev'
  app.use do express.bodyParser
  app.use do express.methodOverride
  app.use app.router
  app.use express.static path.join __dirname, 'public'

app.configure 'development', ->
  app.use do express.errorHandler

{map} = new ControllerBridge app

map.get '/', 'index#index'

server = http.createServer app
server.listen (app.get 'port'), ->
  console.log "Express server listening on port %s", app.get 'port'