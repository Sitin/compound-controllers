"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'


Action = require '../lib/action'


describe.only 'Action', ->
  it 'should use first constructor parameter as an action path', ->
    expect(new Action "controller#action").to.have.property 'action', 'controller#action'

  it 'should use only non empty strings as an action paths', ->
    expect(-> new Action "").to.throw "Action path should be a non-empty string value"
    expect(-> new Action).to.throw "Action path should be a non-empty string value"