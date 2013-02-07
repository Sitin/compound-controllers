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

  # Instantiate Controller:
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
    it 'should check whether requested action exists', ->
      test = undefined
      controller.performAction 'nothing', {}, {}, (err) ->
        test = err
      expect(test).to.be.equal "Error: there no action nothing."

    it 'should request action context creation with passed req, res and next', ->
      test = undefined
      backup = controller.createActionContext
      spy = controller.createActionContext = chai.spy (params) ->
        test = params

      controller.performAction 'action', 'req', 'res', 'next'

      expect(spy).to.be.called.once
      expect(test).to.be.deep.equal req: 'req', res: 'res', next: 'next', requestedAction: 'action'

      controller.createActionContext = backup

    it 'should perform action in created context', ->
      test = undefined
      context = spam: 'eggs'

      backupCAC = controller.createActionContext
      backupA = controller.action
      controller.createActionContext = ->
        context
      spy = controller.action = chai.spy ->
        test = @

      controller.performAction 'action'

      expect(spy).to.be.called.once
      expect(test).to.be.deep.equal context

      controller.createActionContext = backupCAC
      controller.action = backupA

  describe '#_ActionContextConstructor', ->
    it 'should merge passed params into context', ->
      context = spam: 'eggs'
      mixin = eggs: 'spam'
      mix = spam: 'eggs', eggs: 'spam'

      controller._ActionContextConstructor.call context, mixin

      expect(context).to.be.deep.equal mix

