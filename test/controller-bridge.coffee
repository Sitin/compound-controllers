"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

# Mock Express app:
app =
  settings:
    controllers: './base'
    defaultPrototype: -> @isDefaultPrototype = true

# Mock ControllersEngine
class ControllersEngine
  getController: ->
    getActionHandler: ->

# SUT:
ControllerBridge = require '../lib/controller-bridge'

describe 'ControllerBridge', ->
  # Usefull stuff:
  expectCallOnceOnConstruction = (method) ->
    # Backup and mock:
    backup = ControllerBridge.prototype[method]
    spy = ControllerBridge.prototype[method] = chai.spy backup

    # Test:
    new ControllerBridge app, ControllersEngine
    expect(spy).to.be.called.once

    # Restore:
    ControllerBridge.prototype[method] = backup

  it 'should be an injector function', ->
    expect(ControllerBridge).to.be.a 'function'

  it 'should expect application as a first parameter', ->
    expect(-> new ControllerBridge)
      .to.throw "ControllerBridge constructor requires application as a first parameter"

  it 'should expect ControllerEngine constructor as a second parameter', ->
    expect(-> new ControllerBridge app)
      .to.throw "ControllersEngine hasn't been injected into ControllerBridge class"

  it 'should ensure that all required parameters have been passed to constructor', ->
    expectCallOnceOnConstruction 'ensureParameters'

  it 'should import settings from application', ->
    expectCallOnceOnConstruction 'importSettings'

  it 'should setup controller engine', ->
    expectCallOnceOnConstruction 'setupEngine'

  it 'should create mapper', ->
    expectCallOnceOnConstruction 'createMapper'

  describe '#importSettings', ->
    it 'should import base directory and default prototype', ->
      context = app: app
      ControllerBridge.prototype.importSettings.call context
      expect(context.baseDir).to.be.equal app.settings.controllers
      expect(context.defaultPrototype).to.be.deep.equal app.settings.defaultPrototype

  describe '#setupEngine', ->
    # SUT:
    setupEngine = ControllerBridge.prototype.setupEngine

    it 'should instantiate engine', ->
      context = ContollerEngine: -> @isEngine = true
      setupEngine.call context
      expect(context).to.have.property('engine').that.deep.equals isEngine: true

    it 'should pass base directory and default prototype to controller engine constructor', ->
      test = {}
      context =
        baseDir: './base'
        defaultPrototype: 'default'
      spy = chai.spy (baseDir, defaultPrototype) ->
        test.baseDir = baseDir
        test.defaultPrototype = defaultPrototype
      context.ContollerEngine = spy

      setupEngine.call context

      expect(spy).to.be.called.once
      expect(test.baseDir).to.be.equal context.baseDir
      expect(test.defaultPrototype).to.be.equal context.defaultPrototype

