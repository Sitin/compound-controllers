"use strict"


Resource = require __dirname + '/resource'


#
# SingletonResource class represents a bunch of routes for some singleton resource.
#
class SingletonResource extends Resource
  #
  # Constructs a singleton resource object or converts resource object to singleton.
  #
  # Attaches namespace (see {Router#namespace namespace funcion} for details) if specified.
  #
  # If term function passed then it will be treated as a resource with default properties.
  #
  # Merges passed object's properties.
  #
  # @param namespace [Object, Function] properties object or namespace function
  #
  # @return [SingletonResource] singleton object
  #
  constructor: (namespace) ->
    # Attach namespace if specified.
    if typeof namespace is 'function' and not namespace.isTerm  # Because term couldn't be a namespace
      @namespace = namespace
    # Or copy properties from passed object.
    else if typeof namespace is 'object'
      @[name] = value for name, value of namespace

module.exports = SingletonResource