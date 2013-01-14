"use strict"

# Setup chai assertions.
chai = require 'chai'
spies = require 'chai-spies'
chai.use spies
{expect} = chai

# Utilities:
_ = require 'lodash'


Resource = require '../lib/resource'
SingletonResource = require '../lib/singleton-resource'


describe 'SingletonResource', ->
  it 'could be used without parameters', ->
    expect(new SingletonResource).to.be.an.instanceof SingletonResource

  it 'should attach namespace if specified', ->
    expect(new SingletonResource ->).to.respondTo 'namespace'

  it 'should merge properties from passed object', ->
    expect(new SingletonResource name: 'value').to.have.property 'name', 'value'

  it 'should not treat function with "isTerm" property as a namespace', ->
    fn = ->
    fn.isTerm = true
    expect(new SingletonResource fn).not.to.respondTo 'namespace'