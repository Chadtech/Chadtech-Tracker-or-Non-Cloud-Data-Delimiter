(function() {
  var _, arrayToHex, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex;

  module.exports = function(ctx, color, cell, pos) {
    var xOrg, yOrg;
    xOrg = pos[0];
    yOrg = pos[1];
    ctx.fillStyle = '#000000';
    return ctx.fillRect(xOrg, yOrg, cell.w, cell.h);
  };

}).call(this);
