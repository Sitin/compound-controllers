"use strict"


Mapper = require('railway-routes').Map


class ControllerBridge
  constructor: (@app, @ContollerEngine) ->
    do @ensureParameters
    do @importSettings
    do @setupEngine
    do @createMapper

  createMapper: ->
    # Map app requests to routes:
    @map = new Mapper @app, @getHandler

  ensureParameters: ->
    # Application instance is required:
    if not @app?
      throw "ControllerBridge constructor requires application as a first parameter"

    # ContollerEngine is required:
    if not @ContollerEngine?
      throw "ControllersEngine hasn't been injected into ControllerBridge class"

  importSettings: ->
    # Get controllers base dir from app settings:
    @baseDir = @app.settings.controllers

    # Get default prototype from app settings:
    @defaultPrototype = @app.settings.defaultPrototype

  setupEngine: ->
    # Setup controller engine:
    @engine = new @ContollerEngine @baseDir, @defaultPrototype

  getHandler: (ns, controller, action) =>
    instance = @engine.getController ns, controller
    instance.getActionHandler action


module.exports = ControllerBridge