/*
 * GET home page.
 */

(function () {
  "use strict";
  exports.index = function (req, res) {
    res.render('index', { title: 'Express' });
  };
}).call(this);