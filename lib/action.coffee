"use strict"


#
# Action class represents one router action.
#
class Action
  #
  # @property [string] action path
  #
  action: undefined

  #
  # Constructs action object.
  #
  # @param action [string] action route
  #
  # @throw "Action path should be a non-empty string value" if action is not a non-empty string
  #
  constructor: (@action) ->
    # Ensure that action is non-empty string.
    if typeof @action isnt 'string' or not action.length
      throw "Action path should be a non-empty string value"


module.exports = Action