"use strict"

#
# Resource class represents a bunch of routes for some resource.
#
class Resource
  isReadOnly: false
  isWriteOnly: false
  hasOnlyRestrictions: false
  namespace: undefined

  #
  # Constructs a resource object.
  #
  # Attaches namespace (see {Router#namespace namespace funcion} for details) if specified.
  #
  # Merges passed object's properties.
  #
  # @param namespace [Object, Function] properties object or namespace function
  #
  constructor: (namespace) ->
    # Attach namespace if specified.
    if typeof namespace is 'function'
      @namespace = namespace
    # Or copy properties from passed object.
    else if typeof namespace is 'object'
      @[name] = value for name, value of namespace

module.exports = Resource