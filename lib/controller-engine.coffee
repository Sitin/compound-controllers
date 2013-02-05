"use strict"

path = require 'path'
assert = require 'assert'
AbstractController = require __dirname + '/abstract-controller'

class ControllerEngine
  #
  #
  #
  controllers:
    __root__:
      __ancestor__: AbstractController

  #
  # Accepts base directory and default controller ancestor.
  #
  # @param [String] baseDir controllers location
  # @param [Function, Object] defaultAncestor consructor function or factory object
  #
  constructor: (@baseDir, defaultAncestor) ->
    # Set constructor for default namespace:
    @setAncestorForNamespace null, defaultAncestor if defaultAncestor?

  #
  # Returns path to namespace directory.
  #
  # @param [String] ns namespace name
  #
  # @return [String] path to namespace directory
  #
  pathToNamespace: (ns) ->
    ns = '.' if not ns or ns is '__root__'
    path.resolve "#{@baseDir}/#{ns}"

  #
  # Returns filename of controller.
  #
  # @param [String] controllerName controller's route name
  #
  # @return [String] filename
  #
  filenameOfControler: (controllerName) ->
    controllerName + '-controller'

  #
  # Returns ancestor for specified namespace.
  #
  # @param [String] ns namespace name
  # @param [Boolean] relax whether getter should skip loading ancestor if not defined
  #
  # @return [Function, Object] ancestor that is a constructor function or prototype
  #
  ancestorForNamespace: (ns, relax) ->
    # Some namespaces could have special aliases:
    ns = @resolveNamespaceName ns

    # Get defined ancestor:
    ancestor = @controllers[ns].__ancestor__

    # Load ancestor if not defined (doesn't work in 'relax' mode):
    ancestor = @loadNamespaceAncestor ns unless relax or ancestor

    ancestor

  #
  #
  #
  #
  #
  #
  #
  loadNamespaceAncestor: (ns) ->
    # Some namespaces could have special aliases:
    ns = @resolveNamespaceName ns

    # Create namespace if new:
    @controllers[ns] = {} unless @controllers[ns]

    # If ancestor havn't been defined yet it will
    # try to load custom ancestor for namespase
    # and if fails then set a default ancestor:
    if not @ancestorForNamespace ns, yes
      try
        ancestor = @loadControllerModule ns, 'abstract'
      catch loadFails
        ancestor = do @ancestorForNamespace
      finally
        @setAncestorForNamespace ns, ancestor

    @ancestorForNamespace ns

  resolveNamespaceName: (ns) ->
    ns = '__root__' if not ns or ns is '.'
    ns

  #
  # Sets ancestor for controllers in specified namespace
  #
  # @param [String] ns namespace
  # @param [Function, Object] ancestor constructor function or prototype
  #
  setAncestorForNamespace: (ns, ancestor) ->
    # Every namespace should have an ancestor:
    assert.ok typeof ancestor is 'function' or typeof ancestor is 'object',
      "Wrong ancestor #{ancestor.toString()} for namespace '#{ns}'. Ancestor should be either a function or an object."

    # Some namespaces could have special aliases:
    ns = @resolveNamespaceName ns

    # Create namespace if new:
    @controllers[ns] = {} unless @controllers[ns]

    @controllers[ns].__ancestor__ = ancestor

  #
  # Loads controller or returns it from cache
  #
  # @param [String] ns namespace name, empty for the root namespace
  # @param [String] controller controller name
  #
  # @return [Object] controller instance
  #
  getController: (ns, controller) ->
    # Set unnamed namespace to '__root__':
    ns = '__root__' unless ns or ns is '.'

    # Create namespace if new:
    @controllers[ns] = {} unless @ancestorForNamespace ns

    # Load controller if not loaded yet:
    if not @controllers[ns][controller]
      ancestor = @ancestorForNamespace ns
      @controllers[ns][controller] = @loadController ns, controller, ancestor

    # Return controller instance:
    @controllers[ns][controller]

  #
  # Creates controller instance using constructor or assumes that
  # Constructor is an instance if object passed.
  #
  # @param [Function] Constructor
  #
  # @return [Object] controller instance
  makeControllerInstance: (Constructor) ->
    # Controller's module could return either constructor
    # function or a factory object:
    switch typeof Constructor
      when 'function'
        instance = new Constructor
      when 'object'
        instance = Constructor
      else
        throw "Wrong controller constructor"

    # Return controller instance:
    instance

  #
  # Loads controller's module from specified namespace.
  #
  # Controller's module should return function that accepts one parameter -
  # the controller's constructor function or factory object.
  #
  # @param [String] ns controller's namespace
  # @param [String] controller controller's name
  #
  # @return [Function] controller factory method
  loadControllerModule: (ns, controller) ->
    base = @pathToNamespace ns
    filename = @filenameOfControler controller
    require "#{base}/#{filename}"

  #
  # Loads and instantiates controller
  #
  # @param [String] ns controller's namespace
  # @param [String] controller controller's name
  #
  # @return [Object] controller instance
  #
  loadController: (ns, controller) ->
    thatInheritsFrom = @loadControllerModule ns, controller
    @makeControllerInstance thatInheritsFrom @ancestorForNamespace ns

module.exports = ControllerEngine