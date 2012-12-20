"use strict"
path = require 'path'

class ControllerBridge
  controllers:
    __: {}
  constructor: (@app, @Controller) ->
    # Map app requests to railway routes:
    @map = new require('railway-routes').Map(@app, @getHandler);

    # Get controllers base dir from app setteings:
    @baseDir = @app.settings.controllers

  resolveNamespaceDir: (ns) ->
    ns = '.' if not ns or ns == '__'
    path.resolve "#{@baseDir}/#{ns}"

  resolveControllerInstance: (Constructor) ->
    # Controller's module could return either constructor
    # function or an constructor object itself:
    switch typeof Constructor
      when 'function'
        instance = new Constructor(@app)
      when 'object'
        instance = Constructor
      else
        throw "Wrong controller constructor"

    # Return controller instance:
    instance

  loadController: (ns, controller) ->
    base = @resolveNamespaceDir ns
    inherritFrom = require "#{base}/#{controller}"
    @resolveControllerInstance inherritFrom @Controller

  getController: (ns, controller) ->
    # Set unnamed namespace to '__':
    ns = '__' unless ns
    # Create namespace if new:
    @controllers[ns] = {} unless @controllers[ns]?
    # Load controller if not loaded yet:
    if not @controllers[ns][controller]
      @controllers[ns][controller] = @loadController(ns, controller)
    # Return controller instance:
    @controllers[ns][controller]

  getHandler: (ns, controller, action) =>
    instance = @getController(ns, controller)
    method = instance[action]
    ->
      method.apply instance, arguments


module.exports = ControllerBridge