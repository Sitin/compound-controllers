"use strict"

_ = require 'lodash'

class AbstractController
  constructor: ->
    @_ActionContextConstructor.prototype = @

  _ActionContextConstructor: (mixin) ->
    _.merge @, mixin

  createActionContext: (mixin) ->
    context = new @_ActionContextConstructor mixin

  performAction: (action, req, res, next) ->
    # Check if action exists:
    if typeof @[action] isnt 'function'
      next "Error: there no action #{action}."
      return
    # Create action context that will have a current
    # constructor instance as a prototype:
    actionContext = @createActionContext
      req: req
      res: res
      next: next
      requestedAction: action

    # Simply perform the action
    @[action].call actionContext

  getActionHandler: (action) ->
    (req, res, next) =>
      @performAction action, req, res, next

module.exports = AbstractController
