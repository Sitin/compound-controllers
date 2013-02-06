"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

# SUT:
AbstractController = require '../lib/abstract-controller'
class Controller extends AbstractController
  action: ->

describe 'AbstractController', ->
  it 'should be a constructor function', ->
    expect(AbstractController).to.be.a 'function'

  it 'should make current controller instance to be a prototype of the action context', ->
    controller = new AbstractController
    expect(controller._ActionContextConstructor.prototype).to.be.equal controller

  # Instantiate AbstractController (yes, this is all Javascript):
  controller = new Controller

  describe '#getActionHandler', ->
    actionHandler = controller.getActionHandler 'action'

    it 'should return an action handler function', ->
    expect(actionHandler).to.be.a 'function'

    describe 'action handler', ->
      it ['should curry from the left #performAction "action" parameter',
          'and pass first three parameters to it'].join(" "), ->
        test = action: no, params: no
        backup = controller.performAction
        spy = controller.performAction = chai.spy (action, params...) ->
          test.action = action
          test.params = params

        actionHandler 1, 2, 3

        expect(spy).have.been.called.once
        expect(test.action).to.be.equal 'action'
        expect(test.params).to.be.deep.equal [1, 2, 3]

        controller.performAction = backup

  describe '#performAction', ->
