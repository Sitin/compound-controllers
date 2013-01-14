"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'


Resource = require '../lib/resource'


describe 'Resource', ->
  it 'could be used without parameters', ->
    expect(new Resource).to.be.an.instanceof Resource

  it 'should attach namespace if specified', ->
    expect(new Resource ->).to.respondTo 'namespace'

  it 'should merge properties from passed object', ->
    expect(new Resource name: 'value').to.have.property 'name', 'value'