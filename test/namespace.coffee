"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'


Namespace = require '../lib/namespace'
Action = require '../lib/action'


describe 'Namespace', ->
  it 'should use first constructor parameter as a namespace configuration function', ->
    expect(new Namespace ->).to.respondTo 'configurator'

  it 'should use second constructor parameter as an action path', ->
    action = new Action 'controller#action'
    expect(new Namespace (->), action).to.have.property('root')
      .that.deep.equals action

  it 'should use only functions as a namespace configuration functions', ->
    expect(-> new Namespace "Not a function").to.throw "Not a namespace configuration function"
    expect(-> new Namespace).to.throw "Not a namespace configuration function"

  it 'should chech whether root is an action if root specified', ->
    expect(-> new Namespace (->), "Not an action").to.throw "Namespace root should be an instance of Action"