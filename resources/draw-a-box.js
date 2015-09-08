(function() {
  var _, putPixel;

  _ = require('lodash');

  putPixel = require('./drawingUtilities.js').putPixel;

  module.exports = function(ctx, color, cell, pos) {
    var i, j, ref, ref1, results, results1, xOrg, yOrg;
    xOrg = pos[0];
    yOrg = pos[1];
    _.forEach((function() {
      results = [];
      for (var i = 0, ref = cell.w - 1; 0 <= ref ? i <= ref : i >= ref; 0 <= ref ? i++ : i--){ results.push(i); }
      return results;
    }).apply(this), function(pt) {
      var xCor;
      xCor = xOrg + pt;
      putPixel(ctx, color, [xCor, yOrg + cell.h - 1]);
      putPixel(ctx, color, [xCor, yOrg + cell.h]);
      putPixel(ctx, color, [xCor, yOrg]);
      return putPixel(ctx, color, [xCor, yOrg + 1]);
    });
    _.forEach((function() {
      results1 = [];
      for (var j = 0, ref1 = cell.h - 1; 0 <= ref1 ? j <= ref1 : j >= ref1; 0 <= ref1 ? j++ : j--){ results1.push(j); }
      return results1;
    }).apply(this), function(pt) {
      var yCor;
      yCor = yOrg + pt;
      putPixel(ctx, color, [xOrg + cell.w - 1, yCor]);
      putPixel(ctx, color, [xOrg + cell.w, yCor]);
      putPixel(ctx, color, [xOrg, yCor]);
      return putPixel(ctx, color, [xOrg + 1, yCor]);
    });
    return putPixel(ctx, color, [xOrg + cell.w, yOrg + cell.h]);
  };

}).call(this);
