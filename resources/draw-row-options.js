(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(currentSheet, ctx, glyphs, color, cell, Assets) {
    var xCor, yCalc, yCor;
    yCalc = (function(_this) {
      return function(index) {
        return index * (cell.h - 1) + (cell.h * 2);
      };
    })(this);
    xCor = 0;
    _.forEach(currentSheet[0], function(row, rowIndex) {
      var yCor;
      yCor = yCalc(rowIndex);
      ctx.drawImage(Assets['X'][0], xCor + 35, yCor);
      return ctx.drawImage(Assets['^+'][0], xCor, yCor);
    });
    yCor = yCalc(currentSheet[0].length);
    return ctx.drawImage(Assets['^+'][0], xCor, yCor);
  };

}).call(this);
