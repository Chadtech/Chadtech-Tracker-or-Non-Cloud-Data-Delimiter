(function() {
  var _, arrayToHex, drawText, hexToArray, putPixel, ref;

  _ = require('lodash');

  ref = require('./drawingUtilities.js'), putPixel = ref.putPixel, hexToArray = ref.hexToArray, arrayToHex = ref.arrayToHex, drawText = ref.drawText;

  module.exports = function(sheet, ctx, glyphs, color, cell, Assets) {
    var xCor, yCalc;
    yCalc = (function(_this) {
      return function(index) {
        return (index * (cell.h - 1) + (cell.h * 2)) + 1;
      };
    })(this);
    xCor = 0;
    return _.forEach([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], function(rowIndex) {
      var yCor;
      yCor = yCalc(rowIndex);
      ctx.drawImage(Assets['X'][0], xCor + 35, yCor);
      return ctx.drawImage(Assets['^+'][0], xCor, yCor);
    });
  };

}).call(this);
