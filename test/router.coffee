"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'


{Router} = require '../lib'
Resource = require '../lib/resource'
SingletonResource = require '../lib/singleton-resource'

config = require '../lib/router-config'


# List of the DSL tokens.
DSL = [
  'map'
  'read'
  'write'
  'only'
  'resource'
  'except'
  'as'
  'to'
  'namespace'
  'singleton'
]


describe 'Router configuration', ->
  it 'should contain all config sections', ->
    expect(config).have.keys(['readRoutes', 'writeRoutes', 'singletonRoutes'])


describe 'Router', ->
  it 'should be a function', ->
    expect(Router).to.be.a 'function'

  it 'should construct object with all router DSL functions', ->
    expect(Router).to.respondTo name for name in DSL

  # Now we could instantiate router:
  router = new Router
  # And destructure all DSL functions to local context:
  {map, read, write, only, resource, except, as, to, namespace, singleton} = router


  describe '#resource', ->
    it 'should return a resource object', ->
      expect(do resource).to.be.an.instanceof Resource

    it 'should be marked as a term', ->
      expect(resource).to.have.property 'isTerm', true

    it 'should call Resource constructor with specified parameter', ->


  describe '#singleton', ->
    it 'should return a singleton object', ->
      expect(do singleton).to.be.an.instanceof SingletonResource

    it 'should be marked as a term', ->
      expect(singleton).to.have.property 'isTerm', true

    it 'should call SingletonResource constructor with specified parameter', ->


  describe '#only', ->
    it 'should return a resource object', ->
      expect(only resource).to.be.an.instanceof Resource

    it 'should add .hasOnlyRestrictions to resulting object', ->
      expect(only resource).to.have.property 'hasOnlyRestrictions', true

    it 'should treat "resource" or "singleton" terms as a corresponding resources', ->
      expect(only resource).to.deep.equal only do resource
      expect(only singleton).to.deep.equal only do singleton

    it 'should call function if specified as a parameter', ->
      spy = chai.spy resource
      only spy
      expect(spy).to.be.called.once

    it "can't accept anything except resource", ->
      expect(only).to.throw 'Only resources could be passed to only()'
      expect(-> only ->).to.throw 'Only resources could be passed to only()'


  describe '#read', ->
    it 'should return a resource object', ->
      expect(read only resource).to.be.an.instanceof Resource

    it 'should add .isReadOnly to resulting object if used with only()', ->
      expect(read only resource).to.have.property 'isReadOnly', true

    it 'should conflict with write only resources', ->
      expect(-> read write only resource)
        .to.throw "Can't make read only resource that already has a write only restriction"

    it "can't accept anything except resource", ->
      expect(read).to.throw 'Only resources could be passed to read()'
      expect(-> read "").to.throw 'Only resources could be passed to read()'

    it "should check whether passed resource has an 'only' restriction", ->
      expect(-> read resource).to.throw 'The "read" term should be followed by "only"'


  describe '#write', ->
    it 'should return a resource object', ->
      expect(write only resource).to.be.an.instanceof Resource

    it 'should add .isWriteOnly to resulting object if used with only()', ->
      expect(write only resource).to.have.property 'isWriteOnly', true

    it 'should conflict with read only resources', ->
      expect(-> write read only resource)
        .to.throw "Can't make write only resource that already has a read only restriction"

    it "can't accept anything except resource", ->
      expect(write).to.throw 'Only resources could be passed to write()'
      expect(-> write "").to.throw 'Only resources could be passed to write()'

    it "should check whether passed resource has an 'only' restriction", ->
      expect(-> write resource).to.throw 'The "write" term should be followed by "only"'


  describe '#except', ->
    it 'should return an object', ->
      expect(except "delete").to.be.an 'object'

    it 'should put all passed params to .exceptions list', ->
      expect(except 'update', 'delete')
        .to.have.property('exceptions').that.deep.equals ['update', 'delete']

    it 'should trait last param as a namespace if it is a function', ->
      expect(except 'update', ->).to.respondTo 'namespace'
      expect(except 'update', ->)
        .to.have.property('exceptions').that.deep.equals ['update']

    it "should throw exception if no route specified", ->
      expect(except).to.throw "You should pass routes to except()"
      expect(-> except ->).to.throw "You should pass routes to except()"


  describe '#namespace', ->
    it 'should return an object', ->
      expect(namespace ->).to.be.an 'object'

    it 'should return a namespace object', ->
      expect(namespace ->).to.have.property 'type', 'namespace'
      expect(namespace ->).to.respondTo 'namespace'

    it 'should accept only one parameter that is a function', ->
      expect(namespace).to.throw "Namespace is not specified or not a function"
      expect(-> namespace "I am not a function").to.throw "Namespace is not specified or not a function"


  describe '#to', ->
    it 'should return an object', ->
      expect(to 'action').to.be.an 'object'

    it 'should return action if only action specified', ->
      expect(to 'action').to.have.property 'action', 'action'
      expect(to 'action').to.have.property 'type', 'action'

    it 'should return namespace with action if action and namespace function specified', ->
      expect(to 'action', ->).to.have.property 'action', 'action'
      expect(to 'action', ->).to.have.property 'type', 'namespace'
      expect(to 'action', ->).to.respondTo 'namespace'

    it 'should use .namespace() if namespace function was specified', ->
      # Backup namespace function.
      _namespace = Router.prototype.namespace

      Router.prototype.namespace = chai.spy Router.prototype.namespace
      to "action", ->
      expect(Router.prototype.namespace).to.have.been.called.once

      # Restore namespace function.
      Router.prototype.namespace = _namespace

    it 'could accept just namespace object', ->
      expect(to namespace ->).to.have.property 'type', 'namespace'
      expect(to namespace ->).to.respondTo 'namespace'

    it 'should throw exception if neither action nor namespace object specified', ->
      expect(to).to.throw "Function to() needs action or namespace object"
      expect(-> to ->).to.throw "Function to() needs action or namespace object as a first parameter"


  describe '#as', ->
    it 'should return a resource object', ->
      expect(as read only resource).to.be.an.instanceof Resource

    it 'should return the same object if it was specified', ->
      expect(as read only resource).to.deep.equal read only resource

    it 'should convert .resource() or .singleton() function to resource and singleton objects respectively', ->
      expect(as resource).to.deep.equal do resource
      expect(as singleton).to.deep.equal do singleton

    it 'should call function if specified as a parameter', ->
      spy = chai.spy resource
      as spy
      expect(spy).to.be.called.once

    it "shouldn't work if neither resource nor singleton specified", ->
      expect(as).to.throw "Function as() requires resource or singleton as a parameter"
      expect(-> as "Something baad.").to.throw "Function as() requires resource or singleton as a parameter"


  describe '#map', ->