"use strict"
module.exports = (Controller) ->
  class IndexController extends Controller
    index: (req, res, next) ->
      res.render 'index', title: 'Index'