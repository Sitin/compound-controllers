/**
 * Module dependencies.
 */
(function () {
  "use strict";
  var express = require('express'),
    routes = require('./routes'),
    user = require('./routes/user'),
    http = require('http'),
    path = require('path');

  var app = express();

  app.configure(function () {
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
  });

  app.configure('development', function () {
    app.use(express.errorHandler());
  });

  var Controller, ControllerBridge, bridge, handler,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Controller = (function() {

    function Controller(app) {
      this.app = app;
    }

    Controller.prototype.index = function(req, res) {
      return res.render('index', {
        title: 'Express'
      });
    };

    Controller.prototype.user = function(req, res) {
      return res.send("respond with a resource");
    };

    Controller.prototype.render = function() {
      return this.app.render();
    };

    return Controller;

  })();

  ControllerBridge = (function() {

    ControllerBridge.prototype.controllers = {};

    function ControllerBridge(app) {
      this.app = app;
      this.handle = __bind(this.handle, this);
    }

    ControllerBridge.prototype.handle = function(ns, controller, action) {
      if (!this.controllers[controller]) {
        this.controllers[controller] = {
          obj: new Controller(this.app),
          actions: {}
        };
      }
      controller = this.controllers[controller];
      if (controller.actions[action]) {
        return controller.actions[action];
      } else {
        return controller.actions[action] = function() {
          return controller.obj[action].apply(controller.obj, arguments);
        };
      }
    };

    return ControllerBridge;

  })();

  bridge = new ControllerBridge(app);

  handler = bridge.handle;

  var map = new require('railway-routes').Map(app, handler);

  map.get('/', 'Controller#index');
  map.get('/users', 'Controller#list');

  http.createServer(app).listen(app.get('port'), function () {
    console.log("Express server listening on port " + app.get('port'));
  });
}).call(this);