"use strict"


_ = require 'lodash'

{readRoutes, writeRoutes, singletonRoutes} = require __dirname + '/router-config'

Resource = require __dirname + '/resource'
SingletonResource = require __dirname + '/singleton-resource'

class Router
  constructor: ->
    # Resource function should be marked as a term.
    @resource.isTerm = true
    # Singleton function should be marked as a term.
    @singleton.isTerm = true

  #
  # Creates a {Resource resource} object instance with specified parameters..
  #
  # Attaches namespace funcion if specified (see {#namespace}).
  #
  # @param namespace [Function] object with properties or namespace function (see {#namespace})
  #
  # @return [Resource] resource object
  #
  resource: (namespace) ->
    new Resource namespace

  #
  # Creates a {SingletonResource singleton resource} object instance with specified parameters.
  #
  # @param resource [Object, Function] object with properties, {#resource resource term} or namespace function (see {#namespace})
  #
  # @return [SingletonResource] singleton object
  #
  singleton: (resource) ->
    new SingletonResource resource

  #
  # Preconstructs resource object with restricted routes.
  #
  # Produced object could be passed to {#resource resource()}
  # or {#singleton singleton()} functions to restrict their
  # resulting objects to specified routes.
  #
  # Attaches namespace funcion if specified (see {#namespace}).
  #
  # @param routes... [string] routes that should be excluded from resource.
  # @param namespace [Function] optional namespace function (see {#namespace})
  #
  # @return [Object] restrictions object
  #
  except: (routes..., namespace) ->
    # There are should be at least one route.
    if not routes.length and typeof namespace isnt 'string'
      throw "You should pass routes to except()"

    # Put all passed params to .exceptions list.
    resource = exceptions: routes

    # Trait last param as a namespace if it is a function.
    if typeof namespace is 'function'
      resource.namespace = namespace
    # Otherwise it's a route.
    else if namespace?
      resource.exceptions.push namespace

    resource

  #
  # Marks resource object that it has "only" restrictions.
  #
  # Used with {#read read()} and {#write write()}. Otherwise causes an error.
  #
  # @param resource [Resource, Function] resource/singleton objects or {#resource resource}/{#singleton singleton} terms
  #
  # @throw ["Only resources could be passed to only()"] if not a resource specified
  #
  # @return [Resource] resource object with "only" restrictions
  #
  only: (resource) ->
    # Construct resource object if term passed.
    resource = new resource.class if resource?.class
    # Call passed functions if specified.
    resource = do resource if typeof resource is "function"

    # Ensure that resource was passed.
    throw "Only resources could be passed to only()" unless resource instanceof Resource

    # Add .hasOnlyRestrictions property to resulting object:
    _.merge resource, hasOnlyRestrictions: true

  #
  # Marks resource as a read only if precedes to {#only only()}.
  # Opposite to {#write write()}.
  #
  # Could be used only with resource objects that have "only" restriction.
  #
  # @param resource [Resource] resource object
  #
  # @throw ["Only resources could be passed to read()"] if not a resource specified
  # @throw ['The "read" term should be followed by "only"'] if passed object hasn't "only" restriction
  # @throw ["Can't make read only resource that already has a write only restriction"] if passed resource is write only
  #
  # @return [Resource] read only resource
  #
  read: (resource) ->
    # Check that specified parameter is a resource.
    throw "Only resources could be passed to read()" unless resource instanceof Resource

    # Ensure that passed resource has "only" restriction.
    throw 'The "read" term should be followed by "only"' unless resource.hasOnlyRestrictions

    # A resource couldn't be read and write only simultaneously.
    if resource.isWriteOnly
      throw "Can't make read only resource that already has a write only restriction"

    # Mark resource as read.
    _.merge resource, isReadOnly: true

  #
  # Marks resource as a write only if precedes to {#only only()}.
  # Opposite to {#read read()}.
  #
  # Could be used only with resource objects that have "only" restriction.
  #
  # @param resource [Resource] resource object
  #
  # @throw ["Only resources could be passed to write()"] if not a resource specified
  # @throw ['The "write" term should be followed by "only"'] if passed object hasn't "only" restriction
  # @throw ["Can't make write only resource that already has a read only restriction"] if passed resource is read only
  #
  # @return [Resource] write only resource
  #
  write: (resource) ->
    # Check that specified parameter is a resource.
    throw "Only resources could be passed to write()" unless resource instanceof Resource

    # Ensure that passed resource has "only" restriction.
    throw 'The "write" term should be followed by "only"' unless resource.hasOnlyRestrictions

    # A resource couldn't be read and write only simultaneously.
    if resource.isReadOnly
      throw "Can't make write only resource that already has a read only restriction"

    # Mark resource as write.
    _.merge resource, isWriteOnly: true

  #
  # Passes resource object through or converts resource functions to resource object.
  #
  # Converts {#resource resource} and {#singleton singleton} terms to corresponding resource objects.
  #
  # @param resource [Object, Function] resource object or term
  #
  # @throw ["Function as() requires resource or singleton as a parameter"] if not a resource passed
  #
  # @return [Resource] resource object
  #
  as: (resource) ->
    # Call passed functions if specified.
    resource = do resource if typeof resource is "function"

    # We need resource or singleton resource to work with.
    if not (resource instanceof Resource)
      throw "Function as() requires resource or singleton as a parameter"

    resource

  to: (action, namespace) =>
    # We need action or namespace as a first parameter.
    if not action? or (action.type isnt "namespace" and typeof action isnt 'string')
      throw "Function to() needs action or namespace object as a first parameter"

    # If action specified.
    if action.type isnt "namespace"
      # Then convert to action object.
      action =
        type: "action"
        action: action

      # Afterwards convert to namespace if namespace specified.
      if namespace?
        action = _.merge action, @namespace namespace

    # Also could accept namespace object and pass it through
    action

  namespace: (namespace) ->
    # Namespace parameter should be a function.
    if typeof namespace isnt 'function'
      throw "Namespace is not specified or not a function"

    # Return namespace object.
    type:      "namespace"
    namespace: namespace

  map: (route, params) =>
    console.log("Route: ", route);
    console.log("Params: ", params)

module.exports = Router