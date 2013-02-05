"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'

takorogo = require '../index'

describe 'Takorogo as a module', ->
  it 'should return mapper function', ->
    expect(takorogo).to.be.a 'function'