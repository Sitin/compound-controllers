"use strict"

{ControllerBridge, ContollerEngine} = require __dirname + "/lib"

module.exports = (app) ->
  # Create bridge:
  bridge = new ControllerBridge app, ContollerEngine

  # All we need is just a mapper function:
  bridge.map