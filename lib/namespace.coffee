"use strict"


Action = require __dirname + '/action'


#
# Namespace class represents router namespace.
#
class Namespace
  #
  # @property [Function] namespace configuration function
  #
  configurator: undefined
  #
  # @property [Action] namespace root action
  #
  root: undefined

  #
  # Constructs namespace object.
  #
  # @param namespace [Function] action route
  # @param root [Action] optional root action
  #
  constructor: (@configurator, @root) ->
    # Ensure that namespace configurator is a function.
    if typeof @configurator isnt 'function'
      throw "Not a namespace configuration function"

    # Ensure that root is a valid action if root specified.
    if root? and not (root instanceof Action)
      throw "Namespace root should be an instance of Action"


module.exports = Namespace