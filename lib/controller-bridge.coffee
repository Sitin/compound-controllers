"use strict"

ControllersEngine = require __dirname + '/controller-engine'

class ControllerBridge
  constructor: (@app, defaultPrototype) ->
    # Map app requests to railway routes:
    @map = new require('railway-routes').Map(@app, @getHandler);

    # Get controllers base dir from app setteings:
    baseDir = @app.settings.controllers

    # Setup controller engine:
    @engine = new ControllersEngine baseDir, defaultPrototype

  getHandler: (ns, controller, action) =>
    instance = @engine.getController ns, controller
    instance.getActionHandler action

module.exports = ControllerBridge