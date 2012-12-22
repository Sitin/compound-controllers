"use strict"

module.exports = (Controller) ->
  class IndexController extends Controller
    index: ->
      @res.render 'index', title: 'Index'
